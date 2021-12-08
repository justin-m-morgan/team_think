defmodule TeamThinkWeb.LayoutView do
  use TeamThinkWeb, :view

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

  def logo(assigns) do
    ~H"""
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 513.856 513.855" xml:space="preserve" stroke="0" fill="currentColor" class={assigns[:class]}>
    <path d="M302.37.179C179.871-4.066 51.109 67.132 62.235 204.885c.292 9.6 11.341 52.496-31.806 87.397-15.351 12.467-11.289 36.597 10.316 48.489 7.165 3.956 14.658 6.592 22.437 8.425-1.602 8.627-.81 17.356 3.344 25.562-10.161 19.804 3.41 37.851 15.282 42.116 5.581 2.758 1.275 12.751 1.892 21.13 1.731 24.039 30.399 35.698 48.947 32.788 33.248-5.388 70.64-3.676 83.131 32.845 2.496 7.292 8.797 9.287 15.6 10.095 15.089 1.849 188.122-17.641 193.321-20.789 7.252-2.26 13.106-10.38 8.425-19.129-39.974-74.524 40.034-153.645 55.405-225.233C514.452 130.782 413.994.179 302.37.179zm161.749 239.779c-16.696 76.596-89.957 150.648-60.956 230.85-54.477 7.394-164.512 18.966-164.887 19.022-19.609-43.646-65.242-51.48-110.393-44.646-5.964 1.179-18.725-.203-18.385-11.836 3.712-25.649-12.756-40.345-19.261-41.924-2.445-.798-1.424-2.001-1.462-1.966 12.263-13.781-6.198-26.339 3.168-44.097 5.708-10.826-1.627-18.027-13.688-19.692-15.021-1.625-22.952-7.257-28.157-9.562-2.521-1.199-3.499-3.393-1.181-5.967 47.73-43.331 39.608-104.688 39.562-105.249C77.694 71.416 214.071 18.633 303.685 26.422c106.027 9.552 178.354 113.574 160.434 213.536z" />
    <path d="M234.434 138.562c-34.777 20.962-42.051 63.048-27.68 98.871 3.433 8.559 8.95 16.021 13.182 24.163 12.34 23.755 4.062 21.643 4.172 30.682.119 10.593 2.775 29.889 3.895 35.089.899 5.667 5.053 10.734 12.469 10.734 85.45 0 86.872 5.286 91.518-4.854 2.742-4.626 1.762-7.83 1.762-36.054 0-13.508-13.868-1.711 11.648-36.424 6.5-8.839 12.939-17.367 17.164-27.574 8.993-21.751 7.51-46.492-4.215-66.976-24.785-43.386-84.051-51.674-123.915-27.657zm73.13 174.398c-18.514-.762-37.043-.93-55.581-.98a232.907 232.907 0 0 1-1.003-8.582c18.92-.355 37.754.549 56.583 2.442v7.12zm23.48-75.502c-7.57 7.914-18.945 20.035-25.526 41.962a523.433 523.433 0 0 0-13.543-1.117c.035-5.2-2.895-15.671 2.147-35.224.158-.604.219-1.171.27-1.731l13.563-13.566c9.155-9.143-4.718-23.056-13.878-13.883l-6.668 6.66c-2.025-3.41-4.225-6.728-6.723-9.938-6.236-8.018-23.539 1.442-13.884 13.888 3.326 4.271 5.799 9.313 8.211 14.203-3.209 12.868-3.904 25.621-2.392 38.687-6.87-.192-13.749-.3-20.634-.173-1.226-14.051-6.792-23.663-12.172-31.765-3.255-5.294-37.534-56.939 11.641-86.582 27.487-16.562 60.175-7.066 81.71 13.733 25.848 34.644 2.109 60.156-2.122 64.846zm-155.405-51.94c-11.347-.079-22.63-1.031-33.923-2.054-11.893-1.082-11.789 17.44 0 18.509 11.293 1.026 22.576 1.978 33.923 2.057 11.933.075 11.928-18.436 0-18.512zm53.224-75.606c-6.566-9.849-13.238-19.624-20.979-28.604-7.805-9.06-20.83 4.09-13.088 13.088 6.708 7.782 12.395 16.316 18.085 24.854 6.593 9.874 22.629.612 15.982-9.338zm117.213 4.194c4.891-7.825 9.79-15.645 14.391-23.643 5.962-10.367-10.028-19.68-15.975-9.344-4.606 8.003-9.501 15.828-14.396 23.644-6.343 10.161 9.673 19.438 15.98 9.343zm45.875 78.28c11.796-3.306 23.109-7.863 34.083-13.269 10.704-5.284 1.32-21.236-9.333-15.98-9.572 4.717-19.394 8.523-29.666 11.402-11.477 3.214-6.591 21.071 4.916 17.847z" />
    </svg>
    """
  end

end
