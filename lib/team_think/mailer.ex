defmodule TeamThink.Mailer do
  @moduledoc false

  use Swoosh.Mailer, otp_app: :team_think

  @theme_color "#14532d"

  def base_email_template(content) do
    """
    <mjml>
      <mj-body background-color="#{@theme_color}" padding="30px">
        <mj-spacer height="20px" />
        <mj-wrapper background-color="#fbfbfb" padding="50px 30px">
          <mj-section>
              <mj-column>
                  <mj-image height="64px" src="https://www.svgrepo.com/show/99669/idea-hand-drawn-symbol-of-a-side-head-with-a-lightbulb-inside.svg" />

                  <mj-text vertical-align="middle" align="center" font-size="48px" font-weight="bold" font-family="helvetica">TeamThink</mj-text>
              </mj-column>
          </mj-section>
          <mj-section>
              <mj-column>
                  <mj-divider border-color="#{@theme_color}"></mj-divider>
              </mj-column>
          </mj-section>
          #{content}
        </mj-wrapper>
      </mj-body>
    </mjml>
    """
  end
end
