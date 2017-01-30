defmodule WsTest.Sample do

  def connect do
    Socket.Web.connect! "echo.websocket.org"
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
