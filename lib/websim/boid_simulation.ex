defmodule Websim.BoidSimulation do
  use GenServer

  defstruct [data: %{}]
  alias Websim.BoidSimulation

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, %BoidSimulation{}}
  end

  def next_step(socket) do
    GenServer.call(__MODULE__, :next_step)
  end

  def handle_call(:next_step, _from, %{data: old_data}) do
   new_data = iterate_data(old_data)
   {:reply, new_data, %{data: new_data}}
  end
  def handle_call(:next_step, from, %{}) do
    handle_call(:next_step, from, %{data: nil})
  end

  defp iterate_data([]), do: initialize_data()
  defp iterate_data(nil), do: initialize_data()

  defp iterate_data(data) do
    data
    |> Enum.map(fn(%{x: x, y: y, speed: speed, direction: direction}) ->
      %{x: x + speed, y: y + speed, speed: speed, direction: direction} end)
  end

  defp initialize_data() do
    [
      %{x: 1, y: 1, speed: 10, direction: 0},
      %{x: 10, y: 1, speed: 10, direction: 45},
      %{x: 20, y: 1, speed: 10, direction: 90},
      %{x: 1, y: 10, speed: 10, direction: 135},
      %{x: 1, y: 20, speed: 10, direction: 180},
      %{x: 100, y: 100, speed: 10, direction: 180}
    ]
  end

end
