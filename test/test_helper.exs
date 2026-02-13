ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Przetargowi.Repo, :manual)

# Define Mox mocks
Mox.defmock(Przetargowi.UZP.HTTPClientMock, for: Przetargowi.UZP.HTTPClientBehaviour)
