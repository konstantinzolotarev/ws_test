defmodule WsTest.Dubtrack do

  @url "ws://localhost:3000/ws?connect=1"

  def connect do
    Socket.Web.connect! "echo.websocket.org"
  end

  def start_listen(socket) do
    spawn(fn ->
      listen(socket)
    end)
  end

  def listen(socket) do
    case socket |> Socket.Web.recv! do
      {:ping, _} ->
        IO.puts "ping"
        socket |> msg({:pong, ""})

      {:text, data} ->
        IO.inspect data
    end
    socket |> listen
  end

  def msg(socket, data \\ {:text, "test"}) do
    socket |> Socket.Web.send!(data)
  end
end
