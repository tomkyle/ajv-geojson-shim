# ajv-geojson-shim

**A Command-line utility that extends CLI for Ajv JSON schema validators to support GeoJSON files.**

[![CI](https://github.com/tomkyle/ajv-geojson-shim/actions/workflows/ci.yml/badge.svg)](https://github.com/tomkyle/ajv-geojson-shim/actions/workflows/ci.yml)

## Problem

Popular CLI packages for the [Ajv JSON schema validator](https://www.npmjs.com/ajv) do not support validating GeoJSON files directly if their extension is `*.geojson`. The behaviour has been described in [issue 152](https://github.com/ajv-validator/ajv-cli/issues/152) of the canonical but unmaintained [Ajv CLI](https://www.npmjs.com/package/ajv-cli) package.

## Solution

**ajv-geojson-shim** is a bash script wrapper around existing Ajv CLI packages that adds GeoJSON support by:

1. Accepting all standard Ajv CLI arguments and options
2. Detecting `.geojson` files in the parameters
3. Creating temporary `.json` copies of those files
4. Passing the temporary files to the underlying Ajv validator
5. Cleaning up temporary files after validation

## Requirements

Make sure you have installed either [ajv-cli](https://www.npmjs.com/package/ajv-cli) or the actively maintained [@jirutka/ajv-cli](https://www.npmjs.com/package/@jirutka/ajv-cli). You can install them as local dependency or globally using the `-g` flag:

```bash
npm install -g ajv-cli # or
npm install -g @jirutka/ajv-cli
```

## Installation

**Manual Installation:** Clone this repository, make the script executable:

```bash
git clone https://github.com/tomkyle/ajv-geojson-shim.git
```

**Install to your PATH:** This step is optional. It will copy the script to `~/.local/bin/`. Make sure this directory is in your $PATH variable.

```bash
make install
```

## Usage

```bash
ajv-geojson-shim validate -s schema.json -d data.geojson
```

The script supports all commands and options of the underlying *Ajv* CLI package. Some examples:

```bash
# Validate a GeoJSON file against a schema
ajv-geojson-shim validate -s schema.json -d data.geojson

# Validate multiple files, including both JSON and GeoJSON
ajv-geojson-shim validate -s schema.json -d data1.json data2.geojson

# Test a schema with a GeoJSON file
ajv-geojson-shim test -s schema.json -d data.geojson
```

## Development

### Project Structure

```
ajv-geojson-shim/
├── bin/
│   └── ajv-geojson-shim     # Main script
├── test/
│   ├── test-unit.sh         # Unit tests
│   ├── test-integration.sh  # Integration tests
│   ├── test-helpers.sh      # Test helpers
│   └── fixtures/            # Fixture files
│       ├── *.json           # Example JSON and schema 
│       └── *.geoson         # Example GeoJSON
├── Makefile                 # Build and test automation
└── README.md                # Documentation
```

### Testing

The project includes both unit tests and integration tests:

```bash
# Run all tests
make test

# Run only unit/integration tests
make unit-test
make integration-test
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes
4. Run tests to ensure they pass: `make test`
5. Commit your changes: `git commit -m 'Add some amazing feature'`
6. Push to the branch: `git push origin feature/amazing-feature`
7. Open a Pull Request

## Acknowledgements

- [Ajv JSON Schema Validator](https://ajv.js.org/)
- [ajv-cli](https://www.npmjs.com/package/ajv-cli)
- [@jirutka/ajv-cli](https://www.npmjs.com/package/@jirutka/ajv-cli)

## License

[MIT License](./LICENSE) - Copyright (c) 2025 Carsten Witt

