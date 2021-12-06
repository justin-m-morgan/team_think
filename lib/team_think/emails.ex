defmodule TeamThink.Emails do
  @moduledoc """
  Functions for composing email templates
  """

  @base_template_path "base_template.mjml"
  @theme_color_token "papayawhip"
  @theme_color "#14532d"
  @template_directory Path.join([__DIR__, "emails"])
  @external_resource @template_directory


  def generate_template(file_path, tokens \\ []) do
      with {:ok, template} <- compute_path(file_path) |> mjml_to_html() do
        replace_tokens(template, [{@theme_color_token, @theme_color} | tokens ])
      end
  end

  def base_layout(inner_content \\ "") do
    @base_template_path
    |> generate_template([
      {@theme_color_token, @theme_color},
      {"{{content}}", inner_content}
      ])
  end


  defp compute_path(relative_path) do
    Path.join([@template_directory, relative_path])
  end

  defp mjml_to_html(file_path) do
     file_path
      |> File.read!()
      |> Mjml.to_html()
  end

  defp replace_tokens(text, token_pairs) do
    Enum.reduce(token_pairs, text,
      fn {token, replacement}, modified_text ->
        String.replace(modified_text, token, replacement)
      end)
  end

end
