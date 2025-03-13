# Simple Ruby Web App BOSH Release

This BOSH release deploys a simple Ruby web application. The release includes a basic web server that listens on port 8080 and serves a simple web interface.

## Quick Start

To run the application directly:
```bash
cd bosh/ruby-app-release/src/ruby-web-app
bundle exec ruby app.rb
```
The app will be available at http://localhost:8181

## Prerequisites

- BOSH CLI v2+
- Ruby 2.7+ (for development and testing)
- Bundler

## Release Contents

### Jobs

#### rubyweb

The main job that runs the Ruby web application.

**Properties:**
- `port`: The port number the web app listens on (default: 8080)
- `bootstrap`: The main Ruby file to execute (default: "app.rb")

### Packages

#### rubyweb

Contains the Ruby web application code and its dependencies.

## Development

### Setting Up Development Environment

1. Clone this repository:
```bash
git clone <repository-url>
cd ruby-app-release
```

2. Install development dependencies:
```bash
cd unit-tests
bundle install
```

### Running Tests

To run the unit tests:
```bash
cd unit-tests
bundle exec rspec spec/
```

### Creating a Dev Release

To create a development release:
```bash
bosh create-release --force
```

### Creating a Final Release

To create a final release:
```bash
# First create a dev release with a specific version
bosh create-release --force --version=X.Y.Z

# Then finalize it
bosh finalize-release --version=X.Y.Z dev_releases/simple-release/simple-release-X.Y.Z.yml
```

## Deployment

### Prerequisites

- A running BOSH director
- A cloud config with at least one VM type and network
- A stemcell uploaded to your BOSH director

### Deploying

1. Upload the release to your BOSH director:
```bash
bosh upload-release
```

2. Deploy using your manifest:
```bash
bosh -d simple-ruby-app deploy manifest.yml
```

## Troubleshooting

### Common Issues

1. **Port Already in Use**
   - Symptom: The application fails to start
   - Solution: Check if port 8080 is already in use and modify the port property in your manifest

2. **Bootstrap File Not Found**
   - Symptom: The job fails to start
   - Solution: Ensure the bootstrap property points to "app.rb"
