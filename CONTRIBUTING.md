# Contributing to KalyChain Node Installation

Thank you for your interest in contributing to the KalyChain node installation repository! This document provides guidelines for contributing to this project.

## 🤝 How to Contribute

### Reporting Issues

If you encounter bugs or have feature requests:

1. **Search existing issues** to avoid duplicates
2. **Use issue templates** when available
3. **Provide detailed information:**
   - Operating system and version
   - Node type (validator/regular/RPC)
   - Steps to reproduce the issue
   - Expected vs actual behavior
   - Relevant log outputs

### Suggesting Enhancements

We welcome suggestions for improvements:

- **Documentation improvements**
- **Script optimizations**
- **New features or tools**
- **Configuration enhancements**

## 🔧 Development Process

### Getting Started

1. **Fork the repository**
2. **Clone your fork:**
   ```bash
   git clone https://github.com/YOUR_USERNAME/node-install.git
   cd node-install
   ```
3. **Create a feature branch:**
   ```bash
   git checkout -b feature/your-feature-name
   ```

### Making Changes

#### Documentation
- Use clear, concise language
- Follow existing formatting conventions
- Test all commands and procedures
- Update table of contents if needed

#### Scripts
- Follow bash best practices
- Include error handling
- Add comments for complex logic
- Test on Ubuntu 20.04 LTS
- Make scripts executable (`chmod +x`)

#### Configuration Files
- Validate JSON/TOML syntax
- Test configurations thoroughly
- Document any changes
- Maintain backward compatibility when possible

### Testing Your Changes

Before submitting:

1. **Test documentation:**
   - Verify all links work
   - Check formatting renders correctly
   - Test commands on clean system

2. **Test scripts:**
   - Run on fresh Ubuntu 20.04 installation
   - Test error conditions
   - Verify cleanup procedures

3. **Test configurations:**
   - Validate syntax
   - Test with actual node deployment
   - Check for conflicts

### Submitting Changes

1. **Commit your changes:**
   ```bash
   git add .
   git commit -m "feat: add new feature description"
   ```

2. **Push to your fork:**
   ```bash
   git push origin feature/your-feature-name
   ```

3. **Create a Pull Request:**
   - Use descriptive title and description
   - Reference related issues
   - Include testing information
   - Request review from maintainers

## 📝 Style Guidelines

### Documentation Style

- **Use clear headings** with emoji for visual appeal
- **Include code blocks** with proper syntax highlighting
- **Add warnings** for potentially dangerous operations
- **Use tables** for structured information
- **Include examples** for complex procedures

### Code Style

- **Use 2-space indentation** for scripts
- **Include error checking** for critical operations
- **Add logging** with appropriate levels
- **Use meaningful variable names**
- **Comment complex logic**

### Commit Messages

Follow conventional commit format:

- `feat:` - New features
- `fix:` - Bug fixes
- `docs:` - Documentation changes
- `style:` - Formatting changes
- `refactor:` - Code refactoring
- `test:` - Adding tests
- `chore:` - Maintenance tasks

Examples:
```
feat: add automated backup script
fix: correct path in validator configuration
docs: update installation prerequisites
```

## 🔍 Review Process

### What We Look For

- **Functionality:** Does it work as intended?
- **Safety:** Are there proper safeguards?
- **Documentation:** Is it well documented?
- **Testing:** Has it been thoroughly tested?
- **Compatibility:** Works with supported systems?

### Review Timeline

- **Initial review:** Within 1-2 weeks
- **Follow-up:** Based on complexity
- **Merge:** After approval from maintainers

## 🏷️ Release Process

### Versioning

We follow semantic versioning:
- **Major:** Breaking changes
- **Minor:** New features
- **Patch:** Bug fixes

### Release Notes

Include in releases:
- New features
- Bug fixes
- Breaking changes
- Upgrade instructions

## 🆘 Getting Help

Need help contributing?

- 💬 **Discord:** [KalyChain Community](https://discord.gg/bvtm6dUf)
- 📱 **Telegram:** [Developer Group](https://t.me/+yj8Ae9lNXmg1Yzkx)
- 📧 **Email:** Contact maintainers directly

## 📜 Code of Conduct

### Our Standards

- **Be respectful** and inclusive
- **Provide constructive feedback**
- **Focus on what's best** for the community
- **Show empathy** towards other contributors

### Unacceptable Behavior

- Harassment or discrimination
- Trolling or insulting comments
- Publishing private information
- Other unprofessional conduct

### Enforcement

Violations may result in:
- Warning
- Temporary ban
- Permanent ban

Report issues to maintainers.

## 🙏 Recognition

Contributors will be:
- **Listed in release notes**
- **Credited in documentation**
- **Invited to contributor channels**

Thank you for helping make KalyChain better! 🚀
