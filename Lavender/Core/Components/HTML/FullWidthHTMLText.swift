//
//  FullWidthHTMLText.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/22/24.
//

import SwiftUI

struct FullWidthHTMLText: View {
    var content: String

    private var html: String {
    """
        <!doctype html>
        <meta charset="utf-8"/>
        <meta name='viewport' content='width=device-width, shrink-to-fit=YES' initial-scale='1.0' maximum-scale='1.0' minimum-scale='1.0' user-scalable='no'>
        <html>
            <head>
                <style>
                    body {
                        font-size: 16px;
                        font-family: -apple-system-body;
                        text-align: center;
                        height: 100vh;
                        display:flex;
                    }
                    .container{
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        width:90vw;
                        height: 90vh;
                        margin: auto;
                    }
                    .element{
                        margin: auto;
                    }
                </style>
            </head>
            <body>
                <div class="container">
                    <div class="element">
                        \(content)
                    </div>
                </div>
            </body>
        </html>
    """
    }

    var body: some View {
        Text(content.htmlToAttributed)
    }
}

#Preview {
    FullWidthHTMLText(content: "Meow")
}
