defmodule WsTest.Client do

  use GenServer

  def start_link(state \\ []) do
      GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state), do: {:ok, state}

  def connect () do
    IO.puts "test"
  end

end
