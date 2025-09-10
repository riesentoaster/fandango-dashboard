# Fandango Dashboard

![](./dashboard-screenshot.png)

A Smashing dashboard with GitHub Issues integration.

## Running with Docker

### Basic Usage
```bash
docker build -t fandango-dashboard .
docker run --rm -p 3030:3030 fandango-dashboard
```

### With GitHub Issues Integration
To enable the GitHub Issues job, set the following environment variables:

```bash
docker run --rm -p 3030:3030 \
  -e GITHUB_TOKEN=your_github_token \
  -e GITHUB_OWNER=your_username_or_org \
  -e GITHUB_PROJECT=your_repository_name \
  -e GITHUB_SINCE=2024-01-01 \
  fandango-dashboard
```

### Environment Variables
- `GITHUB_TOKEN` - GitHub personal access token (required for API access)
- `GITHUB_OWNER` - GitHub repository owner (username or organization)
- `GITHUB_PROJECT` - GitHub repository name
- `GITHUB_SINCE` - Date to fetch issues since (ISO format: YYYY-MM-DD)

If any of these environment variables are not set, the GitHub Issues job will be disabled automatically.

## Access
Once running, access the dashboard at http://localhost:3030

Check out http://smashing.github.io/smashing for more information.
