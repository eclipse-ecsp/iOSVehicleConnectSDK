
<div align="center">
  <img src="https://github.com/user-attachments/assets/c36c5136-9448-423e-b30b-ed96aa5f8363" width="300" height="150"/>
</div>

# iOS VehicleConnectSDK

[![Build](https://github.com/eclipse-ecsp/iOSVehicleConnectSDK/actions/workflows/ios.yml/badge.svg)](https://github.com/eclipse-ecsp/iOSVehicleConnectSDK/actions/workflows/ios.yml)
[![License Compliance](https://github.com/eclipse-ecsp/iOSVehicleConnectSDK/actions/workflows/license-compliance.yml/badge.svg)](https://github.com/eclipse-ecsp/iOSVehicleConnectSDK/actions/workflows/license-compliance.yml)

Vehicle Connect SDK provides APIs for user authentication using App Auth library, remote operations, vehicle profile management, and vehicle association. It enables mobile applications to be developed with integrated remote vehicle control functionality.

The Vehicle Connect SDK is written in swift and is compatible with iOS 15 and above.
It is capable of establishing a connection to the cloud and retrieving both structured model objects and raw response data.

# Table of Contents
* [Getting Started](#getting-started)
* [Usage](#usage)
* [Built with Dependencies](#built-with-dependencies)
* [How to contribute](#how-to-contribute)
* [Code of Conduct](#code-of-conduct)
* [Contributors](#contributors)
* [Security Contact Information](#security-contact-information)
* [Support](#support)
* [Troubleshooting](#troubleshooting)
* [License](#license)
* [Announcements](#announcements)

## Getting Started

Take clone of the peoject by using the below command and repository path and setup the Xcode version 15.4 amd above 
(git clone https://github.com/eclipse-ecsp/iOSVehicleConnectSDK.git)

Design Overview of VehicleConnectSDK

<img width="1162" alt="VehicleConnectSDK Architecture" src="https://github.com/user-attachments/assets/1aef658c-1793-4849-a384-2afed3782713">

 Developer documentation
 
[VehicleConnectSDK.doccarchive.zip](https://github.com/user-attachments/files/16335249/VehicleConnectSDK.doccarchive.zip)

### Prerequisites
   
SDK has been written in Swift and compatable iOS 16 onward iOS devices.
use the Xcode version 15.4 or above to run the VehicleConnectSDK
VehicleConnectSDK has the capability to make a connection to the cloud and get the response format, model object, and raw data. 

### Installation

 1. Checkout of project, open VehicleConnectSDK.xcworkspace file from the project and run the build from Xcode
 2. use below command to install the cocoapod on the mac machine if not installed by using command
      $ sudo gem install cocoapods
 3.  Go to the project repo and run below command to get the dependency pod in the project
    $ pod install
 4. After build success, Find the VehicleConnectSDK.framework in product folder and add into your project
 5. Import the sdk by using import statement
      Import VehicleConnectSDK
 6. Use the AppManager instance (A class inside the VehicleConnectSDK) to initialise the sdk.
 7. Use the Integration Guid to inegrate the SDK in the app
   [VehicleConnectSDk_Integration_Guide.pdf](https://github.com/user-attachments/files/16837755/VehicleConnectSDk_Integration_Guide.pdf)  
    or Download the sample app  https://github.com/eclipse-ecsp/iOSVehicleConnectApp and see how you can call API methods

 
### CocoaPods
With [CocoaPods](https://guides.cocoapods.org/using/getting-started.html), add the following line to your Podfile:

    pod 'VehicleConnectSDK'

### Coding style check configuration

 Check the coding guidline document 
 [Ignite iOS Coding Guidelines.pdf](https://github.com/user-attachments/files/16709920/Ignite.iOS.Coding.Guidelines.pdf)

 Use swiftlint run for code warnings

### Running the tests

  Run VehicleConnectSDKTests 

### Deployment
Add the VehicleConnectSDK.framework inside app ,open app target and select VehicleConnectSDK.framework  -> build phase -> embeded framework -> embed and sign


## Usage

[VehicleConnectSDK.doccarchive.zip](https://github.com/user-attachments/files/16335249/VehicleConnectSDK.doccarchive.zip)


## Built With Dependencies

* [AppAuth] - Auth library for User Authentication
* [SwiftLint] - Coding convention and style guide


## How to contribute

Please read [CONTRIBUTING.md](https://github.com/eclipse-ecsp/iOSVehicleConnectSDK/blob/main/CONTRIBUTING.md) for details on our contribution guidelines, and the process for submitting pull requests to us.

## Code of Conduct

Please read [CODE_OF_CONDUCT.md](https://github.com/eclipse-ecsp/iOSVehicleConnectSDK/blob/main/CODE_OF_CONDUCT.md) for details on our code of conduct, and the process for submitting pull requests to us.


## Contributors

  Check here the list of [Contributors](https://github.com/eclipse-ecsp/iOSVehicleConnectSDK/graphs/contributors) who participated in this project.
  

## Security Contact Information

Please read [SECURITY.md](./SECURITY.md) to raise any security related issues.

## Support
Please write to us at [csp@harman.com](mailto:csp@harman.com)

## Troubleshooting

Please read [CONTRIBUTING.md](./CONTRIBUTING.md) for details on how to raise an issue and submit a pull request to us.

## License

This project is licensed under the Apache-2.0 License - see the [LICENSE](./LICENSE) file for details.

## Announcements

All updates to this library are present in our [releases page](https://github.com/eclipse-ecsp/iOSVehicleConnectSDK/releases).
For the versions available, see the [tags on this repository](https://github.com/eclipse-ecsp/iOSVehicleConnectSDK/tags).



