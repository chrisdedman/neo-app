defmodule NeoexWeb.NeoController do
  use NeoexWeb, :controller

  @base_url "https://api.nasa.gov/neo/rest/v1/feed?"
  @nasa_api_key Application.get_env(:neo, :nasa_api_key)

  def index(conn, %{"start_date" => start_date, "end_date" => end_date}) do
    url = @base_url <> "start_date=#{start_date}&end_date=#{end_date}&api_key=#{@nasa_api_key}"

    # Fetch and format your data (e.g., from your API or database)
    {:ok, asteroids} = Neoex.NeoApi.process_request_url(url)
    all_asteroids = Neoex.NeoApi.decoder(asteroids, "near_earth_objects", 1)
    element_count = Neoex.NeoApi.decoder(asteroids, "element_count")

    # # Get the first asteroid's self link and replace http with https
    # self_link = hd(asteroids)[:links]["self"]
    # https_url = String.replace(self_link, "http://", "https://")

    # individual_asteroid_data = Neoex.NeoApi.process_request_url(https_url)

    # case individual_asteroid_data do
    #   {:ok, %{"orbital_data" => orbit_class}} ->
    #     orbit_description = orbit_class["orbit_class"]["orbit_class_description"]
    #     first_observation_date = orbit_class["first_observation_date"]
    #     last_observation_date = orbit_class["last_observation_date"]

    #     render(conn, :index, asteroids: asteroids, element_count: element_count, 
    #                         orbit_description: orbit_description,
    #                         first_observation_date: first_observation_date,
    #                         last_observation_date: last_observation_date
    #     )
    #   _ ->
    #     IO.puts("Data structure doesn't match the expected format.")
    # end
    
    # Render the template and pass the data as assigns
    render(conn, :index, layout: false, asteroids: all_asteroids, element_count: element_count)
  end

  def index(conn, _context) do
    {start_date, end_date} = dynamic_dates()
    
    url = @base_url <> "start_date=#{start_date}&end_date=#{end_date}&api_key=#{@nasa_api_key}"

    # Fetch and format your data (e.g., from your API or database)
    {:ok, asteroids} = Neoex.NeoApi.process_request_url(url)
    all_asteroids = Neoex.NeoApi.decoder(asteroids, "near_earth_objects", 1)
    element_count = Neoex.NeoApi.decoder(asteroids, "element_count")
    
    # Render the template and pass the data as assigns
    render(conn, :index, layout: false, asteroids: all_asteroids, element_count: element_count)
  end

  defp dynamic_dates() do
    today = Date.utc_today()
    start_date = Date.to_string(today)
    end_date = Date.to_string(Date.add(today, 0))
    {start_date, end_date}
  end
end
