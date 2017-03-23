defmodule WsTest.Client do
  use GenServer

  @socketUrl "echo.websocket.org"

  def start_link(state \\ %{socket: nil}) do
      GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def text(msg), do: GenServer.cast(__MODULE__, {:text, msg})

  def init(state) do
    socket = Socket.Web.connect! @socketUrl
    # Start proccess
    pid = self()
    send(pid, {:start_listener, pid})
    {:ok, %{state | socket: socket}}
  end

  def pong(socket) do
    socket |> Socket.Web.send!({:pong, ""})
  end

  def listen(socket, pid) do
    IO.puts "Started listen"
    case socket |> Socket.Web.recv! do
      {:text, text} ->
        IO.inspect pid
        # send pid, {:socket, :text, text}
      {:ping, _} ->
        IO.puts "ping received"
        send(pid, {:send_pong})
      {:close, _} ->
        IO.puts "Socket closed !"
        IO.inspect socket
    end
    socket |> listen(pid)
  end

  def handle_cast({:text, msg}, %{socket: socket} = state) do
    socket |> Socket.Web.send!({:text, msg})
    {:noreply, %{state | socket: socket}}
  end

  def handle_info({:start_listener, pid}, %{socket: socket} = state) do
    IO.inspect self()
    socket
    |> listen(pid)

    {:noreply, state}
  end

  def handle_info({:send_pong}, %{socket: socket} = state) do
    IO.puts "Pong sent"
    socket
    |> pong
    {:noreply, state}
  end

end
