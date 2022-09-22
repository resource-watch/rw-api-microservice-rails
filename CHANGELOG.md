# 2.0.0
- Renamed engine to `RW API microservice`
- Drop registration process
- Replace Control Tower references
- Drop legacy `/info` endpoint
- Update Ruby version to `3.1`
- Update Rails version to `~> 7.0.4`

# 1.4.0
- Replace `Authentication: xxx` with `authorization: Bearer xxx` token.

# 1.3.1
- Update rails version dependency to `~>5.1`

# 1.3.0
- Fix issue in body serialization on requests to CT

# 1.2.0
- Fixed the request headers when communicating with CT

# 1.1.0
- Remove dry run support
- Add support for microservice requests
- Replace Faraday with HTTParty gem
- Refactor error handling

# 1.0.0
- Initial support for microservice registration
