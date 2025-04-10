# Ham
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)][mason_link]
[![License: BSD 3-Clause][license_badge]][license_link]

Ham is an adaptive scalable Flutter framework created by [Miguel Angel A. Navarro.][danxor_git]

Layout module still in development.

### Warning: Ham is still in development.

## Installation 💻

**❗ In order to start using Ham Framework you must have the [Flutter SDK][flutter_install_link] installed on your machine.**

Install via `flutter pub add`:

```sh
flutter  pub  add  ham
```

## Continuous Integration 🤖

Ham Framework comes with a built-in [GitHub Actions workflow][github_actions_link] powered by [Very Good Workflows][very_good_workflows_link], but you can also add your preferred CI/CD solution.

Out of the box, on each pull request and push, the CI `formats`, `lints`, and `tests` the code. This ensures the code remains consistent and behaves correctly as you add functionality or make changes. The project uses [Very Good Analysis][very_good_analysis_link] for a strict set of analysis options used by our team. Code coverage is enforced using the [Very Good Workflows][very_good_coverage_link].

## Running Tests 🧪

For first-time users, install the [very_good_cli][very_good_cli_link]:
`dart pub global activate very_good_cli` 

To run all unit tests:
`very_good test --coverage` 

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).
`# Generate Coverage Report genhtml coverage/lcov.info -o coverage/ # Open Coverage Report open coverage/index.html`


## License

Ham is licensed under the BSD 3-Clause License.

Copyright (c) 2025, Ham by Miguel Angel A. Navarro

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1.  Redistributions of source code must retain the above copyright notice, this list of conditions, and the following disclaimer.
    
2.  Redistributions in binary form must reproduce the above copyright notice, this list of conditions, and the following disclaimer in the documentation and/or other materials provided with the distribution.
    
3.  Neither the name of Ham by Miguel Angel A. Navarro nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
    

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.  

[flutter_install_link]:  https://docs.flutter.dev/get-started/install
[github_actions_link]:  https://docs.github.com/en/actions/learn-github-actions
[license_badge]:  https://img.shields.io/badge/license-BSD-3
[license_link]:  https://opensource.org/license/bsd-3-clause
[mason_link]:  https://github.com/felangel/mason
[very_good_analysis_badge]:  https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]:  https://pub.dev/packages/very_good_analysis
[very_good_cli_link]:  https://pub.dev/packages/very_good_cli
[very_good_coverage_link]:  https://github.com/marketplace/actions/very-good-coverage
[very_good_ventures_link]:  https://verygood.ventures
[very_good_ventures_link_light]:  https://verygood.ventures#gh-light-mode-only
[very_good_ventures_link_dark]:  https://verygood.ventures#gh-dark-mode-only
[very_good_workflows_link]:  https://github.com/VeryGoodOpenSource/very_good_workflows
[danxor_git]:  https://github.com/danxorzum