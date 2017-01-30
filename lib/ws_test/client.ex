defmodule WsTest.Client do
  use GenServer

  def start_link(state \\ %{socket: nil}) do
      GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def recv, do: GenServer.cast(__MODULE__, :recv)

  def pong, do: GenServer.call(__MODULE__, :pong)

  def init(state) do
    socket = Socket.Web.connect! "echo.websocket.org"
    {:ok, %{state | socket: socket}}
  end

  def handle_cast(:recv, %{socket: socket} = state) do
    case socket |> Socket.Web.recv! do
      {:text, data} ->
        IO.puts data
      {:ping, _} ->
        IO.puts "ping/pong"
        pong()
    end

    {:noreply, %{state | socket: socket}}
  end

  def handle_call(:pong, _from, %{socket: socket} = state) do
    socket |> Socket.Web.send!({:pong, ""})
    {:noreply, nil, %{state | socket: socket}}
  end
end
