defmodule WsTest.Eris do

  @host "127.0.0.1"
  @port 1337
  @path "/socketrpc"

  def connect do
    Socket.Web.connect!(@host, @port, path: @path)
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

  def get_blockchain_info(socket) do
    socket |> msg({:text, ~s/{"jsonrpc": "2.0", "method": "erisdb.getBlockchainInfo", "id":"1"}/})
  end

  def subscribe_newblock(socket) do
    socket |> msg({:text, ~s/{"jsonrpc": "2.0", "method": "erisdb.eventSubscribe", "id":"1", "params": { "event_id": "NewBlock" }}/})
  end

end
