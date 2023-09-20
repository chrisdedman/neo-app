defmodule Neoex.NeoApi do
  use HTTPoison.Base

  @expected_fields ~w(
    links element_count near_earth_objects
    id neo_reference_id name nasa_jpl_url absolute_magnitude_h
    estimated_diameter kilometers meters miles feet
    is_potentially_hazardous_asteroid close_approach_data
    is_sentry_object orbiting_body
    close_approach_date close_approach_date_full epoch_date_close_approach
    relative_velocity miss_distance
    astronomical lunar kilometers miles
    orbiting_body orbit_type_description last_observation_date
    first_observation_date orbit_class_type
  )

  def process_request_url(url) do
    {:ok, response} = get_data(url)
    process_response_body(response)
  end

  def process_response_body(body) do
    {:ok, _decoded} = Poison.decode(body)
  end

  def decoder(args, context) do
    Map.get(args, context)
  end

  def decoder(args, context, _sec) do
    near_earth_objects = Map.get(args, context)

    Enum.flat_map(near_earth_objects, fn {_date, objects} ->
      Enum.map(objects, fn obj ->
        Map.take(obj, @expected_fields)
        |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
      end)
    end)
  end

  def get_data(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, body}
      {:error, %HTTPoison.Response{status_code: 404}} -> {:error, "Not found :("}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
    end
  end
end
