defmodule WsTest.Client do
  use GenServer

  def start_link(state \\ %{socket: nil}) do
      GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def text, do: GenServer.cast(__MODULE__, :text)

  def init(state) do
    socket = Socket.Web.connect! "echo.websocket.org"
    pid = self()
    spawn(fn -> listen(socket, pid) end)
    {:ok, %{state | socket: socket}}
  end

  def pong(socket) do
    socket |> Socket.Web.send!({:pong, ""})
  end

  def listen(socket, process) do
    case socket |> Socket.Web.recv! do
      {:text, text} ->
        IO.inspect process
        send process, {:socket, :text, text}
      {:ping, _} ->
        IO.puts "ping/pong"
        socket |> pong
    end
    socket |> listen(process)
  end

  def handle_cast(:text, %{socket: socket} = state) do
    socket |> Socket.Web.send!({:text, "Some text"})
    {:noreply, %{state | socket: socket}}
  end

  def handle_info({:socket, :text, text}, state) do
    IO.inspect text
    IO.inspect state
    {:noreply, state}
  end
end
