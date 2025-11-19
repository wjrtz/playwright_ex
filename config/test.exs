import Config

config :playwright_ex, timeout: String.to_integer(System.get_env("PW_TIMEOUT", "500"))
