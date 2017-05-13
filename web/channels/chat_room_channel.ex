defmodule Chatter.ChatRoomChannel do
  use Chatter.Web, :channel

  def join("chat_room:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (chat_room:lobby).
  def handle_in("shout", payload, socket) do
    spawn(__MODULE__, :save_message, [payload])
    #save_message(payload)
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  def save_message(payload) do
    Chatter.Message.changeset(%Chatter.Message{}, payload)
      |> Chatter.Repo.insert
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
