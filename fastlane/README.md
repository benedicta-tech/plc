fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

### bump_version

```sh
[bundle exec] fastlane bump_version
```



----


## Android

### android deploy_parent

```sh
[bundle exec] fastlane android deploy_parent
```

Deploy a new version parent to the Google Play

### android deploy_child

```sh
[bundle exec] fastlane android deploy_child
```

Deploy a new version child to the Google Play

### android promote_to_beta

```sh
[bundle exec] fastlane android promote_to_beta
```



### android promote_to_production

```sh
[bundle exec] fastlane android promote_to_production
```



----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
