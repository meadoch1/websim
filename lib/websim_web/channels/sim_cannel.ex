defmodule WebsimWeb.SimChannel do
  use Phoenix.Channel

  def join("sim:boid", _message, socket) do
    interval = fps_to_interval(1)
    IO.puts("Firing up the timer")
    :timer.send_interval(interval, :tick)
    {:ok, socket}
  end
  def join("sim:" <> _other_sim_id, _params, _socket), do: {:error, %{reason: "undefined sim"}}

  def handle_info(:tick, socket) do
    new_data = Websim.BoidSimulation.next_step(socket)
    broadcast!(socket, "update", %{data: new_data})
    {:noreply, socket}
  end

  defp fps_to_interval(fps) do
    # milliseconds / frames per second
    round(1000 / fps)
  end
end
