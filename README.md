# Marvel Comics

This project based in the Marvel [API](https://developer.marvel.com/docs), list differents comics with information like:

- List characters
- Detail of character (image, information...)
    - Comics where appear
    - Series where appear
- Information of character
    - Wiki
    - Comic link
    - More details

This app is a simple demo to show the functionality of the API with iOS.

## Important

To use API of Marvel you should create account and generate an API key and configure the file [AppConfig.swift](https://github.com/kevincosta29/marvelcomicios/blob/main/marvelcomicios/Common/AppConfig.swift), changing for your created API key.

``` Swift
let PUBLIC_KEY                          : String        = ""
let PRIVATE_KEY                         : String        = ""
```

And the minimum level of iOS for this app is **13.0**.

## Implemented functionality

1. Using **MVC** patron for implement the software.
2. Native implemented network with using [Alamofire](https://github.com/Alamofire/Alamofire).
3. Animations with [Lottie](https://lottiefiles.com).
4. Dark mode fully operative.

## Screensshots

In the image below can see some screenshots of the application in **Dark** and **Light** mode.

![Dark mode](readme-resources/dark.png)

![Light mode](readme-resources/light.png)

## Demo

Quick demo of the application and the functionality in [YouTube](https://youtu.be/2eCF1Wql9gM)

[![Demo app](https://img.youtube.com/vi/2eCF1Wql9gM/0.jpg)](https://youtu.be/2eCF1Wql9gM)


**Copyright © 2021 Kevin Costa. All rights reserved.**