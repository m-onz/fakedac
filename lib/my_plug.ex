
defmodule FileSanitizer do
  @max_length 255
  @allowed_chars ~r/^[a-zA-Z0-9._-]+$/

  def sanitize_filename(filename) when is_binary(filename) do
    filename
    |> String.trim_leading("/")
    |> String.split("/")
    |> List.last()
    |> String.replace("../", "")
    |> String.replace("./", "")
    |> validate_length()
    |> validate_chars()
  end

  def sanitize_filename(_), do: {:error, :invalid_input}

  defp validate_length(filename) when byte_size(filename) <= @max_length, do: filename
  defp validate_length(_), do: {:error, :filename_too_long}

  defp validate_chars(filename) do
    case Regex.match?(@allowed_chars, filename) do
      true -> {:ok, filename}
      false -> {:error, :invalid_characters}
    end
  end
end


defmodule StringProcessor do
  def remove_md_suffix(strings) do
    Enum.map(strings, fn str ->
      String.replace(str, ".md", "")
    end)
  end
end

defmodule EventSorter do
  def sort_events(events) do
    Enum.sort_by(events, &extract_date/1, :asc)
  end

  defp extract_date(filename) do
    case Regex.run(~r/^(\d{4})-(\d{2})-(\d{2})/, filename) do
      [_, year, month, day] ->
        {-String.to_integer(year), -String.to_integer(month), -String.to_integer(day)}
      nil ->
        {:error, filename}
    end
  end
end

defmodule Fakedac.MyPlug do
  use Plug.Router
  @template_dir "lib/templates"
  @events  EventSorter.sort_events(
    StringProcessor.remove_md_suffix(
      File.ls!("lib/templates/events")
      )
    )

  IO.puts(@events)

  plug Plug.Static,
    at: "/assets",
    from: Path.expand("./assets")

  plug :match
  plug :dispatch

  get "/" do
    render(conn, "index.html", assigns: %{test: 11})
  end

  get "/events" do
    render(conn, "events.html", assigns: %{events: @events})
  end

  get "/about" do
    render(conn, "about.html", [])
  end

  get "/contact" do
    render(conn, "contact.html", [])
  end

  get "/media" do
    render(conn, "media.html", [])
  end

  get "/events/:file" do
    # file = Path.join(@template_dir, "/events/#{file}.md")
    case FileSanitizer.sanitize_filename(file) do
      {:ok, sanitized_file} ->
        # IO.puts(sanitized_file)
        file_path = Path.join(@template_dir, "/events/#{sanitized_file}.md")
        case File.read(file_path) do
          {:ok, content} ->
            html_content = Earmark.as_html!(content)
            wrapped_content = render_layout(html_content)
            send_resp(conn, 200, wrapped_content)
          {:error, reason} ->
            send_resp(conn, 404, "File not found: #{reason}")
        end
        # Proceed with file reading
      {:error, reason} ->
        send_resp(conn, 400, "Invalid filename: #{reason}")
    end
  end

  # get "/markdown/:file" do
  #   file = Path.join(@template_dir, "#{file}.md")
  #   case File.read(file) do
  #     {:ok, content} ->
  #       html_content = Earmark.as_html!(content)
  #       wrapped_content = render_layout(html_content)
  #       send_resp(conn, 200, wrapped_content)
  #     {:error, reason} ->
  #       send_resp(conn, 404, "File not found: #{reason}")
  #   end
  # end

  match _ do
    wrapped_content = render_layout("oops")
    send_resp(conn, 404, wrapped_content)
  end

  defp render(conn, template, assigns \\ []) do
    html_content = render_template(template, assigns)
    wrapped_content = render_layout(html_content)
    send_resp(conn, 200, wrapped_content)
  end

  defp render_template(template, assigns \\ []) do
    template_path = Path.join(@template_dir, template <> ".eex")
    EEx.eval_file(template_path, assigns)
  end

  defp render_layout(content) do
    layout_path = Path.join(@template_dir, "layout.html.eex")
    EEx.eval_file(layout_path, assigns: %{content: content})
  end

end
