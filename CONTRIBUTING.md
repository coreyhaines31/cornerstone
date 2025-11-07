# Contributing to Cornerstone

Thank you for your interest in contributing to Cornerstone! We welcome contributions from the community.

## Code of Conduct

By participating in this project, you agree to abide by our code of conduct: be respectful, inclusive, and constructive in all interactions.

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in [Issues](https://github.com/coreyhaines31/cornerstone/issues)
2. Create a new issue with a clear title and description
3. Include steps to reproduce the bug
4. Include your environment details (Ruby version, Rails version, OS)

### Suggesting Features

1. Check if the feature has already been suggested
2. Open a new issue with the "enhancement" label
3. Clearly describe the feature and its use case
4. Explain why this would be valuable for Cornerstone users

### Submitting Pull Requests

1. Fork the repository
2. Create a new branch from `development`:
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. Make your changes following our coding standards

4. Write or update tests for your changes

5. Ensure all tests pass:
   ```bash
   bundle exec rspec
   ```

6. Run linters and fix any issues:
   ```bash
   bundle exec standard
   bundle exec erb_lint --lint-all
   ```

7. Commit your changes with a descriptive message:
   ```bash
   git commit -m "Add feature: description of what you added"
   ```

8. Push to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

9. Create a Pull Request to the `development` branch

## Development Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/coreyhaines31/cornerstone.git
   cd cornerstone
   ```

2. Install dependencies:
   ```bash
   bundle install
   ```

3. Run tests:
   ```bash
   bundle exec rspec
   ```

## Coding Standards

### Ruby Style

We use Standard Ruby for consistent code style:
```bash
bundle exec standard
```

### ERB Templates

We use erb_lint for ERB templates:
```bash
bundle exec erb_lint --lint-all
```

### Commits

- Use clear, descriptive commit messages
- Reference issue numbers when applicable
- Keep commits focused on a single change

### Tests

- Write tests for all new features
- Maintain or improve code coverage
- Use descriptive test names

## Testing the Template

To test the Rails template locally:

1. Create a test Rails app:
   ```bash
   rails new test_app -m template.rb
   ```

2. Verify all features work as expected

3. Test generators:
   ```bash
   cd test_app
   rails g cornerstone:cms
   rails g cornerstone:ai
   ```

## Module Development

When adding new modules:

1. Create the generator in `lib/generators/cornerstone/`
2. Add templates in the generator's `templates/` directory
3. Update the configuration in `config/cornerstone.yml`
4. Document the module in README.md
5. Add tests for the generator

## Documentation

- Update README.md for user-facing changes
- Update CHANGELOG.md following [Keep a Changelog](https://keepachangelog.com/)
- Add inline documentation for complex code
- Update CLAUDE.md if adding new development commands

## Release Process

Releases are managed by maintainers:

1. Update version in `lib/cornerstone/version.rb`
2. Update CHANGELOG.md
3. Create a git tag: `git tag v1.0.0`
4. Push tag: `git push origin v1.0.0`
5. Create GitHub release with changelog

## Questions?

If you have questions, feel free to:
- Open an issue for discussion
- Join our [Discord community](https://discord.gg/cornerstone)
- Reach out on [Twitter](https://twitter.com/cornerstone_rb)

Thank you for contributing to Cornerstone!