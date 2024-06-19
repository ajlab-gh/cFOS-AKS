# Changelog

## [1.0.1](https://github.com/AJLab-GH/cFOS-AKS/compare/v1.0.0...v1.0.1) (2024-06-19)


### Bug Fixes

* [#21](https://github.com/AJLab-GH/cFOS-AKS/issues/21) remove hardcoded container name ([0d45964](https://github.com/AJLab-GH/cFOS-AKS/commit/0d45964d33fafe77680b4ee15d265c57f5e39473))
* [#28](https://github.com/AJLab-GH/cFOS-AKS/issues/28) add basic IP address control ([4b46bef](https://github.com/AJLab-GH/cFOS-AKS/commit/4b46bef359dbbfc378076e90b9c742be656b3c2a))
* [#30](https://github.com/AJLab-GH/cFOS-AKS/issues/30) add basic logging to k8s ([1bf8edb](https://github.com/AJLab-GH/cFOS-AKS/commit/1bf8edb7b2c7fd027ffa9fd0a23160572bca20a9))
* [#32](https://github.com/AJLab-GH/cFOS-AKS/issues/32) terraform fmt ([56e9d10](https://github.com/AJLab-GH/cFOS-AKS/commit/56e9d10a5b0d2d8116b2d31fe9649c290d1e671c))
* [#36](https://github.com/AJLab-GH/cFOS-AKS/issues/36) add working flux application ([ef0580f](https://github.com/AJLab-GH/cFOS-AKS/commit/ef0580f165d4e5a7e6f25b3967d34e6277571d38))
* [#36](https://github.com/AJLab-GH/cFOS-AKS/issues/36) flux application almost works ([80ea22f](https://github.com/AJLab-GH/cFOS-AKS/commit/80ea22f235c961284ca4bcceb0053b03bf971a16))
* [#36](https://github.com/AJLab-GH/cFOS-AKS/issues/36) increase node size to run more pods ([dc49825](https://github.com/AJLab-GH/cFOS-AKS/commit/dc498253bba6549e7402abef5f2af2043d48f759))
* [#41](https://github.com/AJLab-GH/cFOS-AKS/issues/41) change devcontainer ([48f086c](https://github.com/AJLab-GH/cFOS-AKS/commit/48f086c415176e8adb8cebf1618aeae1a42e71e7))
* [#43](https://github.com/AJLab-GH/cFOS-AKS/issues/43) pwsh commands no longer required to import backend pool since migrating to managed networking (Get-AzVmss not recognized) ([cb16b6a](https://github.com/AJLab-GH/cFOS-AKS/commit/cb16b6a8f5dfcaf359dda13c620c156a2c8626cd))
* [#46](https://github.com/AJLab-GH/cFOS-AKS/issues/46) associated kubernetes service to container registry via role_assignment. ([cb16b6a](https://github.com/AJLab-GH/cFOS-AKS/commit/cb16b6a8f5dfcaf359dda13c620c156a2c8626cd))
* [#47](https://github.com/AJLab-GH/cFOS-AKS/issues/47) associated of kubernetes service to acr included AcrPull role definition (fixed as of [#46](https://github.com/AJLab-GH/cFOS-AKS/issues/46)) ([cb16b6a](https://github.com/AJLab-GH/cFOS-AKS/commit/cb16b6a8f5dfcaf359dda13c620c156a2c8626cd))
* [#48](https://github.com/AJLab-GH/cFOS-AKS/issues/48) removed custom networking since private endpoint is not required for use-case. ([cb16b6a](https://github.com/AJLab-GH/cFOS-AKS/commit/cb16b6a8f5dfcaf359dda13c620c156a2c8626cd))
* [#49](https://github.com/AJLab-GH/cFOS-AKS/issues/49) add cfos ([f1b6323](https://github.com/AJLab-GH/cFOS-AKS/commit/f1b6323887f80843514a0c9e818cf97ab8f4a223))
* [#53](https://github.com/AJLab-GH/cFOS-AKS/issues/53) adding cfos to manifest ([acf1c93](https://github.com/AJLab-GH/cFOS-AKS/commit/acf1c93e976e3091333b27fb0806b701fc922528))
* [#53](https://github.com/AJLab-GH/cFOS-AKS/issues/53) adding cfos to manifest ([93e235c](https://github.com/AJLab-GH/cFOS-AKS/commit/93e235c4c62b483f05d4a67a0b5d66573c95f7c5))
* [#53](https://github.com/AJLab-GH/cFOS-AKS/issues/53) adding flux config to repo ([ca3d01c](https://github.com/AJLab-GH/cFOS-AKS/commit/ca3d01c6b1aab9dd1e087e0f157e8d82c647042a))
* [#53](https://github.com/AJLab-GH/cFOS-AKS/issues/53) moving files into manifests folder ([6371f26](https://github.com/AJLab-GH/cFOS-AKS/commit/6371f267ebb0aea29f6c6d17a06417d3696d6e71))
* [#53](https://github.com/AJLab-GH/cFOS-AKS/issues/53) moving files into manifests folder ([358d72e](https://github.com/AJLab-GH/cFOS-AKS/commit/358d72e2e586278b632015ec324198b84f5e18d1))
* changing branch name to dev ([70d3f1a](https://github.com/AJLab-GH/cFOS-AKS/commit/70d3f1a8200b28a929df6c0a14c0133494c89d68))
* changing branch name to dev ([34dc0ed](https://github.com/AJLab-GH/cFOS-AKS/commit/34dc0ed6bfc5f5bc931a8c67ae52ebaae365975a))
* working on [#36](https://github.com/AJLab-GH/cFOS-AKS/issues/36) ([760ecf3](https://github.com/AJLab-GH/cFOS-AKS/commit/760ecf3b23bd0bf5007f06448f4fb793951a59b6))

## 1.0.0 (2024-06-11)


### Bug Fixes

* [#8](https://github.com/AJLab-GH/cFOS-AKS/issues/8) added flux extension to aks ([c6f2f69](https://github.com/AJLab-GH/cFOS-AKS/commit/c6f2f69f4c9b61009bf9cd874f4281f4b908b56a))
