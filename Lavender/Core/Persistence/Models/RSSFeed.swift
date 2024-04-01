//
//  RSSFeed.swift
//  Lavender
//
//  Created by Brianna Zamora on 3/21/24.
//

import Foundation
import SwiftData
import FeedKit

@Model
/// Data model for the XML DOM of the RSS 2.0 Specification
/// See http://cyber.law.harvard.edu/rss/rss.html
///
/// At the top level, an RSS document is a <rss> element, with a mandatory
/// attribute called version, that specifies the version of RSS that the
/// document conforms to. If it conforms to this specification, the version
/// attribute must be 2.0.
///
/// Subordinate to the <rss> element is a single <channel> element, which
/// contains information about the channel (metadata) and its contents.
class RSSFeed {
    var podcast: Podcast? = nil

    /// The name of the channel. It's how people refer to your service. If
    /// you have an HTML website that contains the same information as your
    /// RSS file, the title of your channel should be the same as the title
    /// of your website.
    ///
    /// Example: GoUpstate.com News Headlines
    var title: String? = nil

    /// The URL to the HTML website corresponding to the channel.
    ///
    /// Example: http://www.goupstate.com/
    var link: String? = nil

    /// Phrase or sentence describing the channel.
    ///
    /// Example: The latest news from GoUpstate.com, a Spartanburg Herald-Journal
    /// Web site.
    var feedDescription: String? = nil

    /// The language the channel is written in. This allows aggregators to group
    /// all Italian language sites, for example, on a single page. A list of
    /// allowable values for this element, as provided by Netscape, is here:
    /// http://cyber.law.harvard.edu/rss/languages.html
    ///
    /// You may also use values defined by the W3C:
    /// http://www.w3.org/TR/REC-html40/struct/dirlang.html#langcodes
    ///
    /// Example: en-us
    var language: String? = nil

    /// Copyright notice for content in the channel.
    ///
    /// Example: Copyright 2002, Spartanburg Herald-Journal
    var copyright: String? = nil

    /// Email address for person responsible for editorial content.
    ///
    /// Example: geo@herald.com (George Matesky)
    var managingEditor: String? = nil

    /// Email address for person responsible for technical issues relating to
    /// channel.
    ///
    /// Example: betty@herald.com (Betty Guernsey)
    var webMaster: String? = nil

    /// The publication date for the content in the channel. For example, the
    /// New York Times publishes on a daily basis, the publication date flips
    /// once every 24 hours. That's when the pubDate of the channel changes.
    /// All date-times in RSS conform to the Date and Time Specification of
    /// RFC 822, with the exception that the year may be expressed with two
    /// characters or four characters (four preferred).
    ///
    /// Example: Sat, 07 Sep 2002 00:00:01 GMT
    var pubDate: Date? = nil

    /// The last time the content of the channel changed.
    ///
    /// Example: Sat, 07 Sep 2002 09:42:31 GMT
    var lastBuildDate: Date? = nil

    /// Specify one or more categories that the channel belongs to. Follows the
    /// same rules as the <item>-level category element.
    ///
    /// Example: Newspapers
    var categories: [Category]? = nil

    /// Specify one or more categories that the channel belongs to. Follows the
    /// same rules as the <item>-level category element.
    ///
    /// Example: Newspapers
    struct Category: Codable, Sendable {
        /// A string that identifies a categorization taxonomy. It's an optional
        /// attribute of `<category>`. e.g. "http://www.fool.com/cusips"
        public var domain: String?

        /// The element's value.
        public var value: String?

        init(_ category: FeedKit.RSSFeedCategory?) {
            self.domain = category?.attributes?.domain
            self.value = category?.value
        }
    }

    /// A string indicating the program used to generate the channel.
    ///
    /// Example: MightyInHouse Content System v2.3
    var generator: String? = nil

    /// A URL that points to the documentation for the format used in the RSS
    /// file. It's probably a pointer to this page. It's for people who might
    /// stumble across an RSS file on a Web server 25 years from now and wonder
    /// what it is.
    ///
    /// Example: http://blogs.law.harvard.edu/tech/rss
    var docs: String? = nil

    /// Allows processes to register with a cloud to be notified of updates to
    /// the channel, implementing a lightweight publish-subscribe protocol for
    /// RSS feeds.
    ///
    /// Example: <cloud domain="rpc.sys.com" port="80" path="/RPC2" registerProcedure="pingMe" protocol="soap"/>
    ///
    /// <cloud> is an optional sub-element of <channel>.
    ///
    /// It specifies a web service that supports the rssCloud interface which can
    /// be implemented in HTTP-POST, XML-RPC or SOAP 1.1.
    ///
    /// Its purpose is to allow processes to register with a cloud to be notified
    /// of updates to the channel, implementing a lightweight publish-subscribe
    /// protocol for RSS feeds.
    ///
    /// <cloud domain="rpc.sys.com" port="80" path="/RPC2" registerProcedure="myCloud.rssPleaseNotify" protocol="xml-rpc" />
    ///
    /// In this example, to request notification on the channel it appears in,
    /// you would send an XML-RPC message to rpc.sys.com on port 80, with a path
    /// of /RPC2. The procedure to call is myCloud.rssPleaseNotify.
    ///
    /// A full explanation of this element and the rssCloud interface is here:
    /// http://cyber.law.harvard.edu/rss/soapMeetsRss.html#rsscloudInterface
    var cloud: Cloud? = nil

    struct Cloud: Codable, Sendable {
        /// The domain to register notification to.
        var domain: String?

        /// The port to connect to.
        var port: Int?

        /// The path to the RPC service. e.g. "/RPC2".
        var path: String?

        /// The procedure to call. e.g. "myCloud.rssPleaseNotify" .
        var registerProcedure: String?

        /// The `protocol` specification. Can be HTTP-POST, XML-RPC or SOAP 1.1 -
        /// Note: "protocol" is a reserved keyword, so `protocolSpecification`
        /// is used instead and refers to the `protocol` attribute of the `cloud`
        /// element.
        var protocolSpecification: String?

        init(_ cloud: FeedKit.RSSFeedCloud?) {
            self.domain = cloud?.attributes?.domain
            self.port = cloud?.attributes?.port
            self.path = cloud?.attributes?.path
            self.registerProcedure = cloud?.attributes?.registerProcedure
            self.protocolSpecification = cloud?.attributes?.protocolSpecification
        }
    }

    /// The PICS rating for the channel.
    var rating: String? = nil

    /// ttl stands for time to live. It's a number of minutes that indicates how
    /// long a channel can be cached before refreshing from the source.
    ///
    /// Example: 60
    ///
    /// <ttl> is an optional sub-element of <channel>.
    ///
    /// ttl stands for time to live. It's a number of minutes that indicates how
    /// long a channel can be cached before refreshing from the source. This makes
    /// it possible for RSS sources to be managed by a file-sharing network such
    /// as Gnutella.
    var ttl: Int? = nil

    /// Specifies a GIF, JPEG or PNG image that can be displayed with the channel.
    ///
    /// <image> is an optional sub-element of <channel>, which contains three
    /// required and three optional sub-elements.
    ///
    /// <url> is the URL of a GIF, JPEG or PNG image that represents the channel.
    ///
    /// <title> describes the image, it's used in the ALT attribute of the HTML
    /// <img> tag when the channel is rendered in HTML.
    ///
    /// <link> is the URL of the site, when the channel is rendered, the image
    /// is a link to the site. (Note, in practice the image <title> and <link>
    /// should have the same value as the channel's <title> and <link>.
    ///
    /// Optional elements include <width> and <height>, numbers, indicating the
    /// width and height of the image in pixels. <description> contains text
    /// that is included in the TITLE attribute of the link formed around the
    /// image in the HTML rendering.
    ///
    /// Maximum value for width is 144, default value is 88.
    ///
    /// Maximum value for height is 400, default value is 31.
    var image: Image? = nil

    struct Image: Codable, Sendable {
        /// The URL of a GIF, JPEG or PNG image that represents the channel.
        public var url: String?

        /// Describes the image, it's used in the ALT attribute of the HTML `<img>`
        /// tag when the channel is rendered in HTML.
        public var title: String?

        /// The URL of the site, when the channel is rendered, the image is a link
        /// to the site. (Note, in practice the image `<title>` and `<link>` should
        /// have the same value as the channel's `<title>` and `<link>`.
        public var link: String?

        /// Optional element `<width>` indicating the width of the image in pixels.
        /// Maximum value for width is 144, default value is 88.
        public var width: Int?

        /// Optional element `<height>` indicating the height of the image in pixels.
        /// Maximum value for height is 400, default value is 31.
        public var height: Int?

        /// Contains text that is included in the TITLE attribute of the link formed
        /// around the image in the HTML rendering.
        public var imageDescription: String?

        init(_ image: FeedKit.RSSFeedImage?) {
            self.url = image?.url
            self.title = image?.title
            self.link = image?.link
            self.width = image?.width
            self.height = image?.height
            self.imageDescription = image?.description
        }
    }

    /// Specifies a text input box that can be displayed with the channel.
    ///
    /// A channel may optionally contain a <textInput> sub-element, which contains
    /// four required sub-elements.
    ///
    /// <title> -- The label of the Submit button in the text input area.
    ///
    /// <description> -- Explains the text input area.
    ///
    /// <name> -- The name of the text object in the text input area.
    ///
    /// <link> -- The URL of the CGI script that processes text input requests.
    ///
    /// The purpose of the <textInput> element is something of a mystery. You can
    /// use it to specify a search engine box. Or to allow a reader to provide
    /// feedback. Most aggregators ignore it.
    var textInput: TextInput? = nil

    struct TextInput: Codable, Sendable {
        /// The label of the Submit button in the text input area.
        public var title: String?

        /// Explains the text input area.
        public var textInputDescription: String?

        /// The name of the text object in the text input area.
        public var name: String?

        /// The URL of the CGI script that processes text input requests.
        public var link: String?

        init(_ textInput: FeedKit.RSSFeedTextInput?) {
            self.title = textInput?.title
            self.textInputDescription = textInput?.description
            self.name = textInput?.name
            self.link = textInput?.link
        }
    }

    /// A hint for aggregators telling them which hours they can skip.
    ///
    /// An XML element that contains up to 24 <hour> sub-elements whose value is a
    /// number between 0 and 23, representing a time in GMT, when aggregators, if they
    /// support the feature, may not read the channel on hours listed in the skipHours
    /// element.
    ///
    /// The hour beginning at midnight is hour zero.
    var skipHours: [SkipHour]?

    typealias SkipHour = Int

    /// A hint for aggregators telling them which days they can skip.
    ///
    /// An XML element that contains up to seven <day> sub-elements whose value
    /// is Monday, Tuesday, Wednesday, Thursday, Friday, Saturday or Sunday.
    /// Aggregators may not read the channel during days listed in the skipDays
    /// element.
    var skipDays: [SkipDay]?

    enum SkipDay: String, Codable, Sendable {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday

        init?(_ skipDay: FeedKit.RSSFeedSkipDay) {
            self.init(rawValue: skipDay.rawValue)
        }
    }

    /// A channel may contain any number of <item>s. An item may represent a
    /// "story" -- much like a story in a newspaper or magazine; if so its
    /// description is a synopsis of the story, and the link points to the full
    /// story. An item may also be complete in itself, if so, the description
    /// contains the text (entity-encoded HTML is allowed; see examples:
    /// http://cyber.law.harvard.edu/rss/encodingDescriptions.html), and
    /// the link and title may be omitted. All elements of an item are optional,
    /// however at least one of title or description must be present.
    var items: [Item]? = []

    // MARK: - Namespaces

    /// The Dublin Core Metadata Element Set is a standard for cross-domain
    /// resource description.
    ///
    /// See https://tools.ietf.org/html/rfc5013
    var dublinCore: DublinCore? = nil

    struct DublinCore: Codable, Sendable {
        /// A name given to the resource.
        public var dcTitle: String?

        /// An entity primarily responsible for making the content of the resource
        ///
        /// Examples of a Creator include a person, an organization, or a service.
        /// Typically, the name of a Creator should be used to indicate the entity.
        public var dcCreator: String?

        /// The topic of the content of the resource
        ///
        /// Typically, the subject will be represented using keywords, key phrases,
        /// or classification codes. Recommended best practice is to use a controlled
        /// vocabulary.  To describe the spatial or temporal topic of the resource,
        /// use the Coverage element.
        public var dcSubject: String?

        /// An account of the content of the resource
        ///
        /// Description may include but is not limited to: an abstract, a table of
        /// contents, a graphical representation, or a free-text account of the
        /// resource.
        public var dcDescription: String?

        /// An entity responsible for making the resource available
        ///
        /// Examples of a Publisher include a person, an organization, or a service.
        /// Typically, the name of a Publisher should be used to indicate the entity.
        public var dcPublisher: String?

        /// An entity responsible for making contributions to the content of the
        /// resource
        ///
        /// Examples of a Contributor include a person, an organization, or a service.
        /// Typically, the name of a Contributor should be used to indicate the entity.
        public var dcContributor: String?

        /// A point or period of time associated with an event in the lifecycle of the
        /// resource.
        ///
        /// Date may be used to express temporal information at any level of
        /// granularity. Recommended best practice is to use an encoding scheme, such
        /// as the W3CDTF profile of ISO 8601 [W3CDTF].
        public var dcDate: Date?

        /// The nature or genre of the content of the resource
        ///
        /// Recommended best practice is to use a controlled vocabulary such as the
        /// DCMI Type Vocabulary [DCTYPE].  To describe the file format, physical
        /// medium, or dimensions of the resource, use the Format element.
        public var dcType: String?

        /// The file format, physical medium, or dimensions of the resource.
        ///
        /// Examples of dimensions include size and duration. Recommended best
        /// practice is to use a controlled vocabulary such as the list of Internet
        /// Media Types [MIME].
        public var dcFormat: String?

        /// An unambiguous reference to the resource within a given context.
        ///
        /// Recommended best practice is to identify the resource by means of a string
        /// conforming to a formal identification system.
        public var dcIdentifier: String?

        /// A Reference to a resource from which the present resource is derived
        ///
        /// The described resource may be derived from the related resource in whole
        /// or in part. Recommended best practice is to identify the related resource
        /// by means of a string conforming to a formal identification system.
        public var dcSource: String?

        /// A language of the resource.
        ///
        /// Recommended best practice is to use a controlled vocabulary such as
        /// RFC 4646 [RFC4646].
        public var dcLanguage: String?

        /// A related resource.
        ///
        /// Recommended best practice is to identify the related resource by means of
        /// a string conforming to a formal identification system.
        public var dcRelation: String?

        /// The spatial or temporal topic of the resource, the spatial applicability
        /// of the resource, or the jurisdiction under which the resource is
        /// relevant.
        ///
        /// Spatial topic and spatial applicability may be a named place or a location
        /// specified by its geographic coordinates.  Temporal topic may be a named
        /// period, date, or date range.  A jurisdiction may be a named administrative
        /// entity or a geographic place to which the resource applies.  Recommended
        /// best practice is to use a controlled vocabulary such as the Thesaurus of
        /// Geographic Names [TGN].  Where appropriate, named places or time periods
        /// can be used in preference to numeric identifiers such as sets of
        /// coordinates or date ranges.
        public var dcCoverage: String?

        /// Information about rights held in and over the resource.
        ///
        /// Typically, rights information includes a statement about various property
        /// rights associated with the resource, including intellectual property
        /// rights.
        public var dcRights: String?

        init(_ namespace: DublinCoreNamespace?) {
            self.dcTitle = namespace?.dcTitle
            self.dcCreator = namespace?.dcCreator
            self.dcSubject = namespace?.dcSubject
            self.dcDescription = namespace?.dcDescription
            self.dcPublisher = namespace?.dcPublisher
            self.dcContributor = namespace?.dcContributor
            self.dcDate = namespace?.dcDate
            self.dcType = namespace?.dcType
            self.dcFormat = namespace?.dcFormat
            self.dcIdentifier = namespace?.dcIdentifier
            self.dcSource = namespace?.dcSource
            self.dcLanguage = namespace?.dcLanguage
            self.dcRelation = namespace?.dcRelation
            self.dcCoverage = namespace?.dcCoverage
            self.dcRights = namespace?.dcRights
        }
    }

    /// Provides syndication hints to aggregators and others picking up this RDF Site
    /// Summary (RSS) feed regarding how often it is updated. For example, if you
    /// updated your file twice an hour, updatePeriod would be "hourly" and
    /// updateFrequency would be "2". The syndication module borrows from Ian Davis's
    /// Open Content Syndication (OCS) directory format. It supercedes the RSS 0.91
    /// skipDay and skipHour elements.
    ///
    /// See http://web.resource.org/rss/1.0/modules/syndication/
    var syndication: Syndication? = nil

    struct Syndication: Codable, Sendable {
        /// Describes the period over which the channel format is updated. Acceptable
        /// values are: hourly, daily, weekly, monthly, yearly. If omitted, daily is
        /// assumed.
        public var syUpdatePeriod: UpdatePeriod?

        enum UpdatePeriod: String, Codable, Sendable {
            case hourly, daily, weekly, monthly, yearly

            init?(_ updatePeriod: SyndicationUpdatePeriod?) {
                self.init(rawValue: updatePeriod?.rawValue ?? "")
            }
        }

        /// Used to describe the frequency of updates in relation to the update period.
        /// A positive integer indicates how many times in that period the channel is
        /// updated. For example, an updatePeriod of daily, and an updateFrequency of
        /// 2 indicates the channel format is updated twice daily. If omitted a value
        /// of 1 is assumed.
        public var syUpdateFrequency: Int?

        /// Defines a base date to be used in concert with updatePeriod and
        /// updateFrequency to calculate the publishing schedule. The date format takes
        /// the form: yyyy-mm-ddThh:mm
        public var syUpdateBase: Date?

        init(_ syndication: SyndicationNamespace?) {
            self.syUpdatePeriod = UpdatePeriod(syndication?.syUpdatePeriod)
            self.syUpdateFrequency = syndication?.syUpdateFrequency
            self.syUpdateBase = syndication?.syUpdateBase
        }
    }

    /// iTunes Podcasting Tags are de facto standard for podcast syndication.
    /// See https://help.apple.com/itc/podcasts_connect/#/itcb54353390
    var iTunes: iTunesNamespace? = nil

    struct iTunesNamespace: Codable, Sendable {
        /// The content you specify in the <itunes:author> tag appears in the Artist
        /// column on the iTunes Store. If the tag is not present, the iTunes Store
        /// uses the contents of the <author> tag. If <itunes:author> is not present
        /// at the RSS feed level, the iTunes Store uses the contents of the
        /// <managingEditor> tag.
        var iTunesAuthor: String?

        /// Specifying the <itunes:block> tag with a Yes value in:
        ///
        /// - A <channel> tag (podcast), prevents the entire podcast from appearing on
        /// the iTunes Store podcast directory
        ///
        /// - An <item> tag (episode), prevents that episode from appearing on the
        /// iTunes Store podcast directory
        ///
        /// For example, you might want to block a specific episode if you know that
        /// its content would otherwise cause the entire podcast to be removed from
        /// the iTunes Store. Specifying any value other than Yes has no effect.
        var iTunesBlock: String?

        /// Users can browse podcast subject categories in the iTunes Store by choosing
        /// a category from the Podcasts pop-up menu in the navigation bar. Use the
        /// <itunes:category> tag to specify the browsing category for your podcast.
        ///
        /// You can also define a subcategory if one is available within your category.
        /// Although you can specify more than one category and subcategory in your
        /// feed, the iTunes Store only recognizes the first category and subcategory.
        /// For a complete list of categories and subcategories, see Podcasts Connect
        /// categories.
        ///
        /// Note: When specifying categories and subcategories, be sure to properly
        /// escape ampersands:
        ///
        /// Single category:
        /// <itunes:category text="Music" />
        ///
        /// Category with ampersand:
        /// <itunes:category text="TV &amp; Film" />
        ///
        /// Category with subcategory:
        /// <itunes:category text="Society &amp; Culture">
        /// <itunes:category text="History" />
        /// </itunes:category>
        ///
        /// Multiple categories:
        /// <itunes:category text="Society &amp; Culture">
        /// <itunes:category text="History" />
        /// </itunes:category>
        /// <itunes:category text="Technology">
        /// <itunes:category text="Gadgets" />
        /// </itunes:category>
        var iTunesCategories: [Category]?

        struct Category: Codable, Sendable {
            /// The primary iTunes Category.
            public var text: String?

            /// The iTunes SubCategory.
            public var subcategory: SubCategory?

            init(_ category: ITunesCategory?) {
                self.text = category?.attributes?.text
                self.subcategory = SubCategory(category?.subcategory)
            }

            struct SubCategory: Codable, Sendable {
                /// The primary iTunes Category.
                public var text: String?

                init(_ subcategory: ITunesSubCategory? = nil) {
                    self.text = subcategory?.attributes?.text
                }
            }
        }

        /// Specify your podcast artwork using the <a href> attribute in the
        /// <itunes:image> tag. If you do not specify the <itunes:image> tag, the
        /// iTunes Store uses the content specified in the RSS feed image tag and Apple
        /// does not consider your podcast for feature placement on the iTunes Store or
        /// Podcasts.
        ///
        /// Depending on their device, subscribers see your podcast artwork in varying
        /// sizes. Therefore, make sure your design is effective at both its original
        /// size and at thumbnail size. Apple recommends including a title, brand, or
        /// source name as part of your podcast artwork. For examples of podcast
        /// artwork, see the Top Podcasts. To avoid technical issues when you update
        /// your podcast artwork, be sure to:
        ///
        /// Change the artwork file name and URL at the same time
        /// Verify the web server hosting your artwork allows HTTP head requests
        /// The <itunes:image> tag is also supported at the <item> (episode) level.
        /// For best results, Apple recommends embedding the same artwork within the
        /// metadata for that episode's media file prior to uploading to your host
        /// server; using Garageband or another content-creation tool to edit your
        /// media file if needed.
        ///
        /// Note: Artwork must be a minimum size of 1400 x 1400 pixels and a maximum
        /// size of 3000 x 3000 pixels, in JPEG or PNG format, 72 dpi, with appropriate
        /// file extensions (.jpg, .png), and in the RGB colorspace. These requirements
        /// are different from the standard RSS image tag specifications.
        public var iTunesImage: Image?

        struct Image: Codable, Sendable {
            /// The image's url.
            public var href: String?

            init(_ image: ITunesImage?) {
                self.href = image?.attributes?.href
            }
        }

        /// The content you specify in the <itunes:duration> tag appears in the Time
        /// column in the List View on the iTunes Store.
        ///
        /// Specify one of the following formats for the <itunes:duration> tag value:
        ///
        /// HH:MM:SS
        /// H:MM:SS
        /// MM:SS
        /// M:SS
        ///
        /// Where H = hours, M = minutes, and S = seconds.
        ///
        /// If you specify a single number as a value (without colons), the iTunes
        /// Store displays the value as seconds. If you specify one colon, the iTunes
        /// Store displays the number to the left as minutes and the number to the
        /// right as seconds. If you specify more then two colons, the iTunes Store
        /// ignores the numbers farthest to the right.
        public var iTunesDuration: TimeInterval?

        /// The <itunes:explicit> tag indicates whether your podcast contains explicit
        /// material. You can specify the following values:
        ///
        /// Yes | Explicit | True. If you specify yes, explicit, or true, indicating
        /// the presence of explicit content, the iTunes Store displays an Explicit
        /// parental advisory graphic for your podcast.
        /// Clean | No | False. If you specify clean, no, or false, indicating that
        /// none of your podcast episodes contain explicit language or adult content,
        /// the iTunes Store displays a Clean parental advisory graphic for your
        /// podcast.
        ///
        /// Note: Podcasts containing explicit material are not available in some
        /// iTunes Store territories.
        public var iTunesExplicit: String?

        /// Specifying the <itunes:isClosedCaptioned> tag with a Yes value indicates
        /// that the video podcast episode is embedded with closed captioning and the
        /// iTunes Store should display a closed-caption icon next to the corresponding
        /// episode. This tag is only supported at the <item> level (episode).
        ///
        /// Note: If you specify a value other than Yes, no closed-caption indicator
        /// appears.
        public var isClosedCaptioned: String?

        /// Use the <itunes:order> tag to specify the number value in which you would
        /// like the episode to appear and override the default ordering of episodes
        /// on the iTunes Store.
        ///
        /// For example, if you want an <item> to appear as the first episode of your
        /// podcast, specify the <itunes:order> tag with 1. If conflicting order
        /// values are present in multiple episodes, the iTunes Store uses <pubDate>.
        public var iTunesOrder: Int?

        /// Specifying the <itunes:complete> tag with a Yes value indicates that a
        /// podcast is complete and you will not post any more episodes in the future.
        /// This tag is only supported at the <channel> level (podcast).
        ///
        /// Note: If you specify a value other than Yes, nothing happens.
        public var iTunesComplete: String?

        /// Use the <itunes:new-feed-url> tag to manually change the URL where your
        /// podcast is located. This tag is only supported at a <channel>level
        /// (podcast).
        ///
        /// <itunes:new-feed-url>http://newlocation.com/example.rss</itunes:new-feed-url>
        /// Note: You should maintain your old feed until you have migrated your e
        /// xisting subscribers. For more information, see Update your RSS feed URL.
        public var iTunesNewFeedURL: String?

        /// Use the <itunes:owner> tag to specify contact information for the podcast
        /// owner. Include the email address of the owner in a nested <itunes:email>
        /// tag and the name of the owner in a nested <itunes:name> tag.
        ///
        /// The <itunes:owner> tag information is for administrative communication
        /// about the podcast and is not displayed on the iTunes Store.
        public var iTunesOwner: Owner?

        struct Owner: Codable, Sendable {
            /// The email address of the owner.
            public var email: String?

            /// The name of the owner.
            public var name: String?

            init(_ owner: ITunesOwner?) {
                email = owner?.email
                name = owner?.name
            }
        }

        /// The content you specify in the <itunes:subtitle> tag appears in the
        /// Description column on the iTunes Store. For best results, choose a subtitle
        /// that is only a few words long.
        public var iTunesTitle: String?

        /// The content you specify in the <itunes:subtitle> tag appears in the
        /// Description column on the iTunes Store. For best results, choose a subtitle
        /// that is only a few words long.
        public var iTunesSubtitle: String?

        /// The content you specify in the <itunes:summary> tag appears on the iTunes
        /// Store page for your podcast. You can specify up to 4000 characters. The
        /// information also appears in a separate window if a users clicks the
        /// Information icon (Information icon) in the Description column. If you do
        /// not specify a <itunes:summary> tag, the iTunes Store uses the information
        /// in the <description> tag.
        public var iTunesSummary: String?

        /// Note: The keywords tag is deprecated by Apple and no longer documented in
        /// the official list of tags. However many podcasts still use the tags and it
        /// may be of use for developers building directory or search functionality so
        /// it is included.
        ///
        /// <itunes:keywords>
        /// This tag allows users to search on text keywords.
        /// Limited to 255 characters or less, plain text, no HTML, words must be
        /// separated by spaces.
        /// This tag is applicable to the Item element only.
        public var iTunesKeywords: String?

        /// Use the <itunes:type> tag to indicate how you intend for episodes to be
        /// presented. You can specify the following values:
        ///
        /// episodic | serial. If you specify episodic it means you intend for
        /// episodes to be presented newest-to-oldest. This is the default behavior
        /// in the iTunes Store if the tag is excluded. If you specify serial it
        /// means you intend for episodes to be presented oldest-to-newest.
        public var iTunesType: String?

        /// Use the <itunes:episodeType> tag to indicate what type of show item the
        /// entry is. You can specify the following values:
        ///
        /// full | trailer | bonus. If you specify full, it means this is the full
        /// content of a show. Trailer means this is a preview of the show. Bonus
        /// means it is extra content for a show.
        public var iTunesEpisodeType: String?

        /// Use the <itunes:season> tag to indicate which season the item is part of.
        ///
        /// Note: The iTunes Store & Apple Podcasts does not show the season number
        /// until a feed contains at least two seasons.
        public var iTunesSeason: Int?

        /// Use the <itunes:episode> tag in conjunction with the <itunes:season> tag
        /// to indicate the order an episode should be presented within a season.
        public var iTunesEpisode: Int?

        init(_ namespace: FeedKit.ITunesNamespace?) {
            self.iTunesAuthor = namespace?.iTunesAuthor
            self.iTunesBlock = namespace?.iTunesBlock
            self.iTunesCategories = namespace?.iTunesCategories?.map { Category($0) }
            self.iTunesImage = Image(namespace?.iTunesImage)
            self.iTunesDuration = namespace?.iTunesDuration
            self.iTunesExplicit = namespace?.iTunesExplicit
            self.isClosedCaptioned = namespace?.isClosedCaptioned
            self.iTunesOrder = namespace?.iTunesOrder
            self.iTunesComplete = namespace?.iTunesComplete
            self.iTunesNewFeedURL = namespace?.iTunesNewFeedURL
            self.iTunesOwner = Owner(namespace?.iTunesOwner)
            self.iTunesTitle = namespace?.iTunesTitle
            self.iTunesSubtitle = namespace?.iTunesSubtitle
            self.iTunesSummary = namespace?.iTunesSummary
            self.iTunesKeywords = namespace?.iTunesKeywords
            self.iTunesType = namespace?.iTunesType
            self.iTunesEpisodeType = namespace?.iTunesEpisodeType
            self.iTunesSeason = namespace?.iTunesSeason
            self.iTunesEpisode = namespace?.iTunesEpisode
        }
    }

    init(_ feed: FeedKit.RSSFeed?) {
        guard let feed else {
            return
        }
        self.title = feed.title
        self.link = feed.link
        self.feedDescription = feed.description
        self.language = feed.language
        self.copyright = feed.copyright
        self.managingEditor = feed.managingEditor
        self.webMaster = feed.webMaster
        self.pubDate = feed.pubDate
        self.lastBuildDate = feed.lastBuildDate
        self.categories = feed.categories?.map { Category($0) }
        self.generator = feed.generator
        self.docs = feed.docs
        self.cloud = Cloud(feed.cloud)
        self.rating = feed.rating
        self.ttl = feed.ttl
        self.image = Image(feed.image)
        self.textInput = TextInput(feed.textInput)
        self.skipHours = feed.skipHours
        self.skipDays = feed.skipDays?.compactMap { SkipDay($0) }
        self.items = feed.items?.map({ Item($0) }) ?? []
        self.dublinCore = DublinCore(feed.dublinCore)
        self.syndication = Syndication(feed.syndication)
        self.iTunes = iTunesNamespace(feed.iTunes)
    }

    init() {}
}

@Model
class Item {
    var id = UUID()

    var progress: Float = 0

    var currentlyPlaying: CurrentlyPlaying?

    var podcast: Podcast?

    @Relationship(inverse: \RSSFeed.items)
    var feed: RSSFeed?

    /// The title of the item.
    ///
    /// Example: Venice Film Festival Tries to Quit Sinking
    public var title: String?

    /// The URL of the item.
    ///
    /// Example: http://nytimes.com/2004/12/07FEST.html
    public var link: String?

    /// The item synopsis.
    ///
    /// Example: Some of the most heated chatter at the Venice Film Festival this
    /// week was about the way that the arrival of the stars at the Palazzo del
    /// Cinema was being staged.
    public var itemDescription: String?

    /// Email address of the author of the item.
    ///
    /// Example: oprah\@oxygen.net
    ///
    /// <author> is an optional sub-element of <item>.
    ///
    /// It's the email address of the author of the item. For newspapers and
    /// magazines syndicating via RSS, the author is the person who wrote the
    /// article that the <item> describes. For collaborative weblogs, the author
    /// of the item might be different from the managing editor or webmaster.
    /// For a weblog authored by a single individual it would make sense to omit
    /// the <author> element.
    ///
    /// <author>lawyer@boyer.net (Lawyer Boyer)</author>
    public var author: String?

    /// Includes the item in one or more categories.
    ///
    /// <category> is an optional sub-element of <item>.
    ///
    /// It has one optional attribute, domain, a string that identifies a
    /// categorization taxonomy.
    ///
    /// The value of the element is a forward-slash-separated string that
    /// identifies a hierarchic location in the indicated taxonomy. Processors
    /// may establish conventions for the interpretation of categories.
    ///
    /// Two examples are provided below:
    ///
    /// <category>Grateful Dead</category>
    /// <category domain="http://www.fool.com/cusips">MSFT</category>
    ///
    /// You may include as many category elements as you need to, for different
    /// domains, and to have an item cross-referenced in different parts of the
    /// same domain.
    public var categories: [Category]?

    struct Category: Codable, Sendable {
        /// A string that identifies a categorization taxonomy. It's an optional
        /// attribute of `<category>`.
        ///
        /// Example: http://www.fool.com/cusips
        public var domain: String?

        /// The element's value.
        public var value: String?

        init(_ category: FeedKit.RSSFeedItemCategory?) {
            self.domain = category?.attributes?.domain
            self.value = category?.value
        }
    }

    /// URL of a page for comments relating to the item.
    ///
    /// Example: http://www.myblog.org/cgi-local/mt/mt-comments.cgi?entry_id=290
    ///
    /// <comments> is an optional sub-element of <item>.
    ///
    /// If present, it is the url of the comments page for the item.
    ///
    /// <comments>http://ekzemplo.com/entry/4403/comments</comments>
    ///
    /// More about comments here:
    /// http://cyber.law.harvard.edu/rss/weblogComments.html
    public var comments: String?

    /// Describes a media object that is attached to the item.
    ///
    /// <enclosure> is an optional sub-element of <item>.
    ///
    /// It has three required attributes. url says where the enclosure is located,
    /// length says how big it is in bytes, and type says what its type is, a
    /// standard MIME type.
    ///
    /// The url must be an http url.
    ///
    /// <enclosure url="http://www.scripting.com/mp3s/weatherReportSuite.mp3"
    /// length="12216320" type="audio/mpeg" />
    public var enclosure: Enclosure?

    struct Enclosure: Codable, Sendable {
        /// Where the enclosure is located.
        ///
        /// Example: http://www.scripting.com/mp3s/weatherReportSuite.mp3
        public var url: URL?

        /// How big the media object is in bytes.
        ///
        /// Example: 12216320
        public var length: Int64?

        /// Standard MIME type.
        ///
        /// Example: audio/mpeg
        public var type: String?

        init(_ enclosure: FeedKit.RSSFeedItemEnclosure?) {
            if let urlString = enclosure?.attributes?.url, let url = URL(string: urlString) {
                self.url = url
            }
            self.length = enclosure?.attributes?.length
            self.type = enclosure?.attributes?.type
        }
    }

    /// A string that uniquely identifies the item.
    ///
    /// Example: http://inessential.com/2002/09/01.php#a2
    ///
    /// <guid> is an optional sub-element of <item>.
    ///
    /// guid stands for globally unique identifier. It's a string that uniquely
    /// identifies the item. When present, an aggregator may choose to use this
    /// string to determine if an item is new.
    ///
    /// <guid>http://some.server.com/weblogItem3207</guid>
    ///
    /// There are no rules for the syntax of a guid. Aggregators must view them
    /// as a string. It's up to the source of the feed to establish the
    /// uniqueness of the string.
    ///
    /// If the guid element has an attribute named "isPermaLink" with a value of
    /// true, the reader may assume that it is a permalink to the item, that is,
    /// a url that can be opened in a Web browser, that points to the full item
    /// described by the <item> element. An example:
    ///
    /// <guid isPermaLink="true">http://inessential.com/2002/09/01.php#a2</guid>
    ///
    /// isPermaLink is optional, its default value is true. If its value is false,
    /// the guid may not be assumed to be a url, or a url to anything in
    /// particular.
    public var guid: GUID?

    struct GUID: Codable, Sendable {
        /// The element's attributes.
        /// If the guid element has an attribute named "isPermaLink" with a value of
        /// true, the reader may assume that it is a permalink to the item, that is,
        /// a url that can be opened in a Web browser, that points to the full item
        /// described by the <item> element. An example:
        ///
        /// <guid isPermaLink="true">http://inessential.com/2002/09/01.php#a2</guid>
        ///
        /// isPermaLink is optional, its default value is true. If its value is false,
        /// the guid may not be assumed to be a url, or a url to anything in
        /// particular.
        var isPermaLink: Bool?

        /// The element's value.
        var value: String?

        init(_ guid: FeedKit.RSSFeedItemGUID?) {
            self.isPermaLink = guid?.attributes?.isPermaLink
            self.value = guid?.value
        }
    }

    /// Indicates when the item was published.
    ///
    /// Example: Sun, 19 May 2002 15:21:36 GMT
    ///
    /// <pubDate> is an optional sub-element of <item>.
    ///
    /// Its value is a date, indicating when the item was published. If it's a
    /// date in the future, aggregators may choose to not display the item until
    /// that date.
    public var pubDate: Date?

    /// The RSS channel that the item came from.
    ///
    /// <source> is an optional sub-element of <item>.
    ///
    /// Its value is the name of the RSS channel that the item came from, derived
    /// from its <title>. It has one required attribute, url, which links to the
    /// XMLization of the source.
    ///
    /// <source url="http://www.tomalak.org/links2.xml">Tomalak's Realm</source>
    ///
    /// The purpose of this element is to propagate credit for links, to
    /// publicize the sources of news items. It can be used in the Post command
    /// of an aggregator. It should be generated automatically when forwarding
    /// an item from an aggregator to a weblog authoring tool.
    public var source: Source?

    struct Source: Codable, Sendable {
        /// Required attribute of the `Source` element, which links to the
        /// XMLization of the source. e.g. "http://www.tomalak.org/links2.xml"
        public var url: String?

        /// The element's value.
        public var value: String?

        init(_ source: FeedKit.RSSFeedItemSource?) {
            self.url = source?.attributes?.url
            self.value = source?.value
        }
    }

    // MARK: - Namespaces

    /// The Dublin Core Metadata Element Set is a standard for cross-domain
    /// resource description.
    ///
    /// See https://tools.ietf.org/html/rfc5013
    public var dublinCore: RSSFeed.DublinCore?

    /// A module for the actual content of websites, in multiple formats.
    ///
    /// See http://web.resource.org/rss/1.0/modules/content/
    public var content: Content?

    struct Content: Codable, Sendable {
        /// An element whose contents are the entity-encoded or CDATA-escaped version
        /// of the content of the item.
        ///
        /// Example:
        /// <content:encoded><![CDATA[<p>What a <em>beautiful</em> day!</p>]]>
        /// </content:encoded>
        public var contentEncoded: String?

        init(_ namespace: ContentNamespace?) {
            self.contentEncoded = namespace?.contentEncoded
        }
    }

    /// iTunes Podcasting Tags are de facto standard for podcast syndication.
    /// see https://help.apple.com/itc/podcasts_connect/#/itcb54353390
    public var itunes: RSSFeed.iTunesNamespace?

    /// Media RSS is a new RSS module that supplements the <enclosure>
    /// capabilities of RSS 2.0.
    public var media: Media?

    struct Media: Codable, Sendable {
        /// The <media:group> element is a sub-element of <item>. It allows grouping
        /// of <media:content> elements that are effectively the same content,
        /// yet different representations. For instance: the same song recorded
        /// in both the WAV and MP3 format. It's an optional element that must
        /// only be used for this purpose.
        public var mediaGroup: Group?

        struct Group: Codable, Sendable {
            /// <media:content> is a sub-element of either <item> or <media:group>.
            /// Media objects that are not the same content should not be included
            /// in the same <media:group> element. The sequence of these items implies
            /// the order of presentation. While many of the attributes appear to be
            /// audio/video specific, this element can be used to publish any type of
            /// media. It contains 14 attributes, most of which are optional.
            public var mediaContents: [Content]?

            /// Notable entity and the contribution to the creation of the media object.
            /// Current entities can include people, companies, locations, etc. Specific
            /// entities can have multiple roles, and several entities can have the same
            /// role. These should appear as distinct <media:credit> elements. It has two
            /// optional attributes.
            public var mediaCredits: [Credit]?

            /// Allows a taxonomy to be set that gives an indication of the type of media
            /// content, and its particular contents. It has two optional attributes.
            public var mediaCategory: Category?

            /// This allows the permissible audience to be declared. If this element is not
            /// included, it assumes that no restrictions are necessary. It has one
            /// optional attribute.
            public var mediaRating: Rating?

            init(_ group: MediaGroup?) {
                self.mediaContents = group?.mediaContents?.map { Content($0) }
                self.mediaCredits = group?.mediaCredits?.map { Credit($0) }
                self.mediaCategory = Category(group?.mediaCategory)
                self.mediaRating = Rating(group?.mediaRating)
            }
        }

        struct Title: Codable, Sendable {
            /// Specifies the type of text embedded. Possible values are either "plain" or "html".
            /// Default value is "plain". All HTML must be entity-encoded. It is an optional attribute.
            public var type: String?

            /// The element's value.
            public var value: String?

            init(_ title: MediaTitle?) {
                self.type = title?.attributes?.type
                self.value = title?.value
            }
        }

        struct Description: Codable, Sendable {
            /// Specifies the type of text embedded. Possible values are either "plain" or "html".
            /// Default value is "plain". All HTML must be entity-encoded. It is an optional attribute.
            public var type: String?

            /// The element's value.
            public var value: String?

            init(_ description: MediaDescription?) {
                self.type = description?.attributes?.type
                self.value = description?.value
            }
        }

        struct Player: Codable, Sendable {
            /// The URL of the player console that plays the media. It is a required attribute.
            public var url: String?

            /// The width of the browser window that the URL should be opened in. It is
            /// an optional attribute.
            public var width: Int?

            /// The height of the browser window that the URL should be opened in. It is an
            /// optional attribute.
            public var height: Int?

            /// The element's value.
            public var value: String?

            init(_ player: MediaPlayer?) {
                self.url = player?.attributes?.url
                self.width = player?.attributes?.width
                self.height = player?.attributes?.height
                self.value = player?.value
            }
        }

        struct Thumbnail: Codable, Sendable {
            /// Specifies the url of the thumbnail. It is a required attribute.
            public var url: String?

            /// Specifies the height of the thumbnail. It is an optional attribute.
            public var width: String?

            /// Specifies the width of the thumbnail. It is an optional attribute.
            public var height: String?

            /// Specifies the time offset in relation to the media object. Typically this
            /// is used when creating multiple keyframes within a single video. The format
            /// for this attribute should be in the DSM-CC's Normal Play Time (NTP) as used in
            /// RTSP [RFC 2326 3.6 Normal Play Time]. It is an optional attribute.
            public var time: String?

            /// The element's value.
            public var value: String?

            init(_ thumbnail: MediaThumbnail?) {
                self.url = thumbnail?.attributes?.url
                self.width = thumbnail?.attributes?.width
                self.height = thumbnail?.attributes?.height
                self.time = thumbnail?.attributes?.time
                self.value = thumbnail?.value
            }
        }

        struct Category: Codable, Sendable {

            /// The URI that identifies the categorization scheme. It is an optional
            /// attribute. If this attribute is not included, the default scheme
            /// is "http://search.yahoo.com/mrss/category_schema".
            public var scheme: String?

            /// The human readable label that can be displayed in end user
            /// applications. It is an optional attribute.
            public var label: String?

            /// The element's value.
            public var value: String?

            init(_ category: MediaCategory?) {
                self.scheme = category?.attributes?.scheme
                self.label = category?.attributes?.label
                self.value = category?.value
            }
        }

        struct Content: Codable, Sendable {
            /// The title of the particular media object. It has one optional attribute.
            public var mediaTitle: Title?

            /// Short description describing the media object typically a sentence in
            /// length. It has one optional attribute.
            public var mediaDescription: Description?

            /// Allows the media object to be accessed through a web browser media player
            /// console. This element is required only if a direct media url attribute is
            /// not specified in the <media:content> element. It has one required attribute
            /// and two optional attributes.
            public var mediaPlayer: Player?

            /// Allows particular images to be used as representative images for the
            /// media object. If multiple thumbnails are included, and time coding is not
            /// at play, it is assumed that the images are in order of importance. It has
            /// one required attribute and three optional attributes.
            public var mediaThumbnails: [Thumbnail]?

            /// Highly relevant keywords describing the media object with typically a
            /// maximum of 10 words. The keywords and phrases should be comma-delimited.
            public var mediaKeywords: [String]?

            /// Allows a taxonomy to be set that gives an indication of the type of media
            /// content, and its particular contents. It has two optional attributes.
            public var mediaCategory: Category?

            /// Should specify the direct URL to the media object. If not included,
            /// a <media:player> element must be specified.
            public var url: String?

            /// The number of bytes of the media object. It is an optional
            /// attribute.
            public var fileSize: Int?

            /// The standard MIME type of the object. It is an optional attribute.
            public var type: String?

            /// Tpe of object (image | audio | video | document | executable).
            /// While this attribute can at times seem redundant if type is supplied,
            /// it is included because it simplifies decision making on the reader
            /// side, as well as flushes out any ambiguities between MIME type and
            /// object type. It is an optional attribute.
            public var medium: String?

            /// Determines if this is the default object that should be used for
            /// the <media:group>. There should only be one default object per
            /// <media:group>. It is an optional attribute.
            public var isDefault: Bool?

            /// Determines if the object is a sample or the full version of the
            /// object, or even if it is a continuous stream (sample | full | nonstop).
            /// Default value is "full". It is an optional attribute.
            public var expression: String?

            /// The kilobits per second rate of media. It is an optional attribute.
            public var bitrate: Int?

            /// The number of frames per second for the media object. It is an
            /// optional attribute.
            public var framerate: Double?

            /// The number of samples per second taken to create the media object.
            /// It is expressed in thousands of samples per second (kHz).
            /// It is an optional attribute.
            public var samplingrate: Double?

            /// The number of audio channels in the media object. It is an
            /// optional attribute.
            public var channels: Int?

            /// The number of seconds the media object plays. It is an
            /// optional attribute.
            public var duration: Int?

            /// The height of the media object. It is an optional attribute.
            public var height: Int?

            /// The width of the media object. It is an optional attribute.
            public var width: Int?

            /// The primary language encapsulated in the media object.
            /// Language codes possible are detailed in RFC 3066. This attribute
            /// is used similar to the xml:lang attribute detailed in the
            /// XML 1.0 Specification (Third Edition). It is an optional
            /// attribute.
            public var lang: String?

            init(_ content: MediaContent?) {
                self.mediaTitle = Title(content?.mediaTitle)
                self.mediaDescription = Description(content?.mediaDescription)
                self.mediaPlayer = Player(content?.mediaPlayer)
                self.mediaThumbnails = content?.mediaThumbnails?.map { Thumbnail($0) }
                self.mediaKeywords = content?.mediaKeywords
                self.mediaCategory = Category(content?.mediaCategory)
                self.url = content?.attributes?.url
                self.fileSize = content?.attributes?.fileSize
                self.type = content?.attributes?.type
                self.medium = content?.attributes?.medium
                self.isDefault = content?.attributes?.isDefault
                self.expression = content?.attributes?.expression
                self.bitrate = content?.attributes?.bitrate
                self.framerate = content?.attributes?.framerate
                self.samplingrate = content?.attributes?.samplingrate
                self.channels = content?.attributes?.channels
                self.duration = content?.attributes?.duration
                self.height = content?.attributes?.height
                self.width = content?.attributes?.width
                self.lang = content?.attributes?.lang
            }
        }

        /// <media:content> is a sub-element of either <item> or <media:group>.
        /// Media objects that are not the same content should not be included
        /// in the same <media:group> element. The sequence of these items implies
        /// the order of presentation. While many of the attributes appear to be
        /// audio/video specific, this element can be used to publish any type of
        /// media. It contains 14 attributes, most of which are optional.
        public var mediaContents: [Content]?

        /// This allows the permissible audience to be declared. If this element is not
        /// included, it assumes that no restrictions are necessary. It has one
        /// optional attribute.
        public var mediaRating: Rating?

        struct Rating: Codable, Sendable {
            /// The URI that identifies the rating scheme. It is an optional attribute.
            /// If this attribute is not included, the default scheme is urn:simple (adult | nonadult).
            public var scheme: String?

            /// The element's value.
            public var value: String?

            init(_ rating: MediaRating?) {
                self.scheme = rating?.attributes?.scheme
                self.value = rating?.value
            }
        }

        /// The title of the particular media object. It has one optional attribute.
        public var mediaTitle: Title?

        /// Short description describing the media object typically a sentence in
        /// length. It has one optional attribute.
        public var mediaDescription: Description?

        /// Highly relevant keywords describing the media object with typically a
        /// maximum of 10 words. The keywords and phrases should be comma-delimited.
        public var mediaKeywords: [String]?

        /// Allows particular images to be used as representative images for the
        /// media object. If multiple thumbnails are included, and time coding is not
        /// at play, it is assumed that the images are in order of importance. It has
        /// one required attribute and three optional attributes.
        public var mediaThumbnails: [Thumbnail]?

        /// Allows a taxonomy to be set that gives an indication of the type of media
        /// content, and its particular contents. It has two optional attributes.
        public var mediaCategory: Category?

        /// This is the hash of the binary media file. It can appear multiple times as
        /// long as each instance is a different algo. It has one optional attribute.
        public var mediaHash: Hash?

        struct Hash: Codable, Sendable {
            /// This is the hash of the binary media file. It can appear multiple times as long as
            /// each instance is a different algo. It has one optional attribute.
            public var algo: String?

            /// The element's value.
            public var value: String?

            init(_ hash: MediaHash?) {
                self.algo = hash?.attributes?.algo
                self.value = hash?.value
            }
        }

        /// Allows the media object to be accessed through a web browser media player
        /// console. This element is required only if a direct media url attribute is
        /// not specified in the <media:content> element. It has one required attribute
        /// and two optional attributes.
        public var mediaPlayer: Player?

        /// Notable entity and the contribution to the creation of the media object.
        /// Current entities can include people, companies, locations, etc. Specific
        /// entities can have multiple roles, and several entities can have the same
        /// role. These should appear as distinct <media:credit> elements. It has two
        /// optional attributes.
        public var mediaCredits: [Credit]?

        struct Credit: Codable, Sendable {
            /// Specifies the role the entity played. Must be lowercase. It is an
            /// optional attribute.
            public var role: String?

            /// The URI that identifies the role scheme. It is an optional attribute
            /// and possible values for this attribute are ( urn:ebu | urn:yvs ) . The
            /// default scheme is "urn:ebu". The list of roles supported under urn:ebu
            /// scheme can be found at European Broadcasting Union Role Codes. The
            /// roles supported under urn:yvs scheme are ( uploader | owner ).
            public var scheme: String?

            /// The element's value.
            public var value: String?

            init(_ credit: MediaCredit?) {
                self.role = credit?.attributes?.role
                self.scheme = credit?.attributes?.scheme
                self.value = credit?.value
            }
        }

        /// Copyright information for the media object. It has one optional attribute.
        public var mediaCopyright: Copyright?

        struct Copyright: Codable, Sendable {
            /// The URL for a terms of use page or additional copyright information.
            /// If the media is operating under a Creative Commons license, the
            /// Creative Commons module should be used instead. It is an optional
            /// attribute.
            public var url: String?

            /// The element's value.
            public var value: String?

            init(_ copyright: MediaCopyright?) {
                self.url = copyright?.attributes?.url
                self.value = copyright?.value
            }
        }

        /// Allows the inclusion of a text transcript, closed captioning or lyrics of
        /// the media content. Many of these elements are permitted to provide a time
        /// series of text. In such cases, it is encouraged, but not required, that the
        /// elements be grouped by language and appear in time sequence order based on
        /// the start time. Elements can have overlapping start and end times. It has
        /// four optional attributes.
        public var mediaText: Text?

        struct Text: Codable, Sendable {
            /// Specifies the type of text embedded. Possible values are either "plain"
            /// or "html". Default value is "plain". All HTML must be entity-encoded.
            /// It is an optional attribute.
            public var type: String?

            /// The primary language encapsulated in the media object. Language codes
            /// possible are detailed in RFC 3066. This attribute is used similar to
            /// the xml:lang attribute detailed in the XML 1.0 Specification (Third
            /// Edition). It is an optional attribute.
            public var lang: String?

            /// Specifies the start time offset that the text starts being relevant to
            /// the media object. An example of this would be for closed captioning.
            /// It uses the NTP time code format (see: the time attribute used in
            /// <media:thumbnail>). It is an optional attribute.
            public var start: String?

            /// Specifies the end time that the text is relevant. If this attribute is
            /// not provided, and a start time is used, it is expected that the end
            /// time is either the end of the clip or the start of the next
            /// <media:text> element.
            public var end: String?

            /// The element's value.
            public var value: String?

            init(_ text: MediaText?) {
                self.type = text?.attributes?.type
                self.lang = text?.attributes?.lang
                self.start = text?.attributes?.start
                self.end = text?.attributes?.end
                self.value = text?.value
            }
        }

        /// Allows restrictions to be placed on the aggregator rendering the media in
        /// the feed. Currently, restrictions are based on distributor (URI), country
        /// codes and sharing of a media object. This element is purely informational
        /// and no obligation can be assumed or implied. Only one <media:restriction>
        /// element of the same type can be applied to a media object -- all others
        /// will be ignored. Entities in this element should be space-separated.
        /// To allow the producer to explicitly declare his/her intentions, two
        /// literals are reserved: "all", "none". These literals can only be used once.
        /// This element has one required attribute and one optional attribute (with
        /// strict requirements for its exclusion).
        public var mediaRestriction: Restriction?

        struct Restriction: Codable, Sendable {
            /// Indicates the type of relationship that the restriction represents
            /// (allow | deny). In the example above, the media object should only be
            /// syndicated in Australia and the United States. It is a required
            /// attribute.
            ///
            /// Note: If the "allow" element is empty and the type of relationship is
            /// "allow", it is assumed that the empty list means "allow nobody" and
            /// the media should not be syndicated.
            public var relationship: String?

            /// Specifies the type of restriction (country | uri | sharing ) that the
            /// media can be syndicated. It is an optional attribute; however can only
            /// be excluded when using one of the literal values "all" or "none".
            public var type: String?

            /// The element's value.
            public var value: String?

            init(_ restriction: MediaRestriction?) {
                self.relationship = restriction?.attributes?.relationship
                self.type = restriction?.attributes?.type
                self.value = restriction?.value
            }
        }

        /// This element stands for the community related content. This allows
        /// inclusion of the user perception about a media object in the form of view
        /// count, ratings and tags.
        public var mediaCommunity: Community?

        struct Community: Codable, Sendable {
            /// This element specifies the rating-related information about a media object.
            /// Valid attributes are average, count, min and max.
            public var mediaStarRating: StarRating?

            /// This element specifies various statistics about a media object like the
            /// view count and the favorite count. Valid attributes are views and favorites.
            public var mediaStatistics: Statistics?

            /// This element contains user-generated tags separated by commas in the
            /// decreasing order of each tag's weight. Each tag can be assigned an integer
            /// weight in tag_name:weight format. It's up to the provider to choose the way
            /// weight is determined for a tag; for example, number of occurences can be
            /// one way to decide weight of a particular tag. Default weight is 1.
            public var mediaTags: [Tag]?

            init(_ community: MediaCommunity?) {
                self.mediaStarRating = StarRating(community?.mediaStarRating)
                self.mediaStatistics = Statistics(community?.mediaStatistics)
                self.mediaTags = community?.mediaTags?.map { Tag($0) }
            }
        }

        struct StarRating: Codable, Sendable {
            /// The star rating's average.
            public var average: Double?

            /// The star rating's total count.
            public var count: Int?

            /// The star rating's minimum value.
            public var min: Int?

            /// The star rating's maximum value.
            public var max: Int?

            init(_ starRating: MediaStarRating?) {
                self.average = starRating?.attributes?.average
                self.count = starRating?.attributes?.count
                self.min = starRating?.attributes?.min
                self.max = starRating?.attributes?.max
            }
        }

        struct Statistics: Codable, Sendable {
            /// The number of views.
            public var views: Int?

            /// The number fo favorites.
            public var favorites: Int?

            init(_ statistics: MediaStatistics?) {
                self.views = statistics?.attributes?.views
                self.favorites = statistics?.attributes?.favorites
            }
        }

        struct Tag: Codable, Sendable {
            /// The tag name.
            public var tag: String?

            /// The tag weight. Default to 1 if not specified.
            public var weight: Int? = 1

            init(_ tag: MediaTag?) {
                self.tag = tag?.tag
                self.weight = tag?.weight
            }
        }

        /// Allows inclusion of all the comments a media object has received.
        public var mediaComments: [String]?

        /// Sometimes player-specific embed code is needed for a player to play any
        /// video. <media:embed> allows inclusion of such information in the form of
        /// key-value pairs.
        public var mediaEmbed: Embed?

        struct Embed: Codable, Sendable {
            /// The location of the embeded media.
            public var url: String?

            /// The width size for the embeded Media.
            public var width: Int?

            /// The height size for the embeded Media.
            public var height: Int?

            /// Key-Value pairs with aditional parameters for the embeded Media.
            public var mediaParams: [Param]?

            init(_ embed: MediaEmbed?) {
                self.url = embed?.attributes?.url
                self.width = embed?.attributes?.width
                self.height = embed?.attributes?.height
                self.mediaParams = embed?.mediaParams?.map { Param($0) }
            }
        }

        struct Param: Codable, Sendable {
            /// The parameter's key name.
            public var name: String?

            /// The element's value.
            public var value: String?

            init(_ param: MediaParam?) {
                self.name = param?.attributes?.name
                self.value = param?.value
            }
        }

        /// Allows inclusion of a list of all media responses a media object has
        /// received.
        public var mediaResponses: [String]?

        /// Allows inclusion of all the URLs pointing to a media object.
        public var mediaBackLinks: [String]?

        /// Optional tag to specify the status of a media object -- whether it's still
        /// active or it has been blocked/deleted.
        public var mediaStatus: Status?

        struct Status: Codable, Sendable {
            /// State can have values "active", "blocked" or "deleted". "active" means
            /// a media object is active in the system, "blocked" means a media object
            /// is blocked by the publisher, "deleted" means a media object has been
            /// deleted by the publisher.
            public var state: String?

            /// A reason explaining why a media object has been blocked/deleted. It can
            /// be plain text or a URL.
            public var reason: String?

            init(_ status: MediaStatus?) {
                self.state = status?.attributes?.state
                self.reason = status?.attributes?.reason
            }
        }

        /// Optional tag to include pricing information about a media object. If this
        /// tag is not present, the media object is supposed to be free. One media
        /// object can have multiple instances of this tag for including different
        /// pricing structures. The presence of this tag would mean that media object
        /// is not free.
        public var mediaPrices: [Price]?

        struct Price: Codable, Sendable {
            /// Valid values are "rent", "purchase", "package" or "subscription". If
            /// nothing is specified, then the media is free.
            public var type: String?

            /// The price of the media object. This is an optional attribute.
            public var price: Double?

            /// If the type is "package" or "subscription", then info is a URL pointing
            /// to package or subscription information. This is an optional attribute.
            public var info: String?

            /// Use [ISO 4217] for currency codes. This is an optional attribute.
            public var currency: String?

            /// The element's value.
            public var value: String?

            init(_ price: MediaPrice?) {
                self.type = price?.attributes?.type
                self.price = price?.attributes?.price
                self.info = price?.attributes?.info
                self.currency = price?.attributes?.currency
                self.value = price?.value
            }
        }

        /// Optional link to specify the machine-readable license associated with the
        /// content.
        public var mediaLicense: License?

        struct License: Codable, Sendable {
            /// The licence type.
            public var type: String?

            /// The location of the licence.
            public var href: String?

            /// The element's value.
            public var value: String?

            init(_ license: MediaLicence?) {
                self.type = license?.attributes?.type
                self.href = license?.attributes?.href
                self.value = license?.value
            }
        }

        /// Optional link to specify the machine-readable license associated with the
        /// content.
        public var mediaSubTitle: SubTitle?

        struct SubTitle: Codable, Sendable {
            /// The type of the subtitle.
            public var type: String?

            /// The subtitle language based on the RFC 3066.
            public var lang: String?

            /// The location of the subtitle.
            public var href: String?

            init(_ subtitle: MediaSubTitle?) {
                self.type = subtitle?.attributes?.type
                self.lang = subtitle?.attributes?.lang
                self.href = subtitle?.attributes?.href
            }
        }

        /// Optional element for P2P link.
        public var mediaPeerLink: PeerLink?

        struct PeerLink: Codable, Sendable {
            /// The peer link's type.
            public var type: String?

            /// The location of the peer link provider.
            public var href: String?

            /// The element's value.
            public var value: String?

            init(_ peerLink: MediaPeerLink?) {
                self.type = peerLink?.attributes?.type
                self.href = peerLink?.attributes?.href
                self.value = peerLink?.value
            }
        }

        /// Optional element to specify geographical information about various
        /// locations captured in the content of a media object. The format conforms
        /// to geoRSS.
        public var mediaLocation: Location?

        struct Location: Codable, Sendable {
            /// Description of the place whose location is being specified.
            public var locationDescription: String?

            /// Time at which the reference to a particular location starts in the
            /// media object.
            public var start: TimeInterval?

            /// Time at which the reference to a particular location ends in the media
            /// object.
            public var end: TimeInterval?

            /// The geoRSS's location latitude.
            public var latitude: Double?

            /// The geoRSS's location longitude.
            public var longitude: Double?

            init(_ location: MediaLocation?) {
                self.locationDescription = location?.attributes?.description
                self.start = location?.attributes?.start
                self.end = location?.attributes?.end
                self.latitude = location?.latitude
                self.longitude = location?.longitude
            }
        }

        /// Optional element to specify the rights information of a media object.
        public var mediaRights: Rights?

        struct Rights: Codable, Sendable {
            /// Is the status of the media object saying whether a media object has
            /// been created by the publisher or they have rights to circulate it.
            /// Supported values are "userCreated" and "official".
            public var status: String?

            init(_ rights: MediaRights?) {
                self.status = rights?.attributes?.status
            }
        }

        /// Optional element to specify various scenes within a media object. It can
        /// have multiple child <media:scene> elements, where each <media:scene>
        /// element contains information about a particular scene. <media:scene> has
        /// the optional sub-elements <sceneTitle>, <sceneDescription>,
        /// <sceneStartTime> and <sceneEndTime>, which contains title, description,
        /// start and end time of a particular scene in the media, respectively.
        public var mediaScenes: [Scene]?

        struct Scene: Codable, Sendable {
            /// The scene's title.
            public var sceneTitle: String?

            /// The scene's description.
            public var sceneDescription: String?

            /// The scene's start time.
            public var sceneStartTime: TimeInterval?

            /// The scene's end time.
            public var sceneEndTime: TimeInterval?

            init(_ scene: MediaScene?) {
                self.sceneTitle = scene?.sceneTitle
                self.sceneDescription = scene?.sceneDescription
                self.sceneStartTime = scene?.sceneStartTime
                self.sceneEndTime = scene?.sceneEndTime
            }
        }

        init(_ media: MediaNamespace?) {
            self.mediaGroup = Group(media?.mediaGroup)
            self.mediaContents = media?.mediaContents?.map { Content($0) }
            self.mediaRating = Rating(media?.mediaRating)
            self.mediaTitle = Title(media?.mediaTitle)
            self.mediaDescription = Description(media?.mediaDescription)
            self.mediaKeywords = media?.mediaKeywords
            self.mediaThumbnails = media?.mediaThumbnails?.map { Thumbnail($0) }
            self.mediaCategory = Category(media?.mediaCategory)
            self.mediaHash = Hash(media?.mediaHash)
            self.mediaPlayer = Player(media?.mediaPlayer)
            self.mediaCredits = media?.mediaCredits?.map { Credit($0) }
            self.mediaCopyright = Copyright(media?.mediaCopyright)
            self.mediaText = Text(media?.mediaText)
            self.mediaRestriction = Restriction(media?.mediaRestriction)
            self.mediaCommunity = Community(media?.mediaCommunity)
            self.mediaComments = media?.mediaComments
            self.mediaEmbed = Embed(media?.mediaEmbed)
            self.mediaResponses = media?.mediaResponses
            self.mediaBackLinks = media?.mediaBackLinks
            self.mediaStatus = Status(media?.mediaStatus)
            self.mediaPrices = media?.mediaPrices?.map { Price($0) }
            self.mediaLicense = License(media?.mediaLicense)
            self.mediaSubTitle = SubTitle(media?.mediaSubTitle)
            self.mediaPeerLink = PeerLink(media?.mediaPeerLink)
            self.mediaLocation = Location(media?.mediaLocation)
            self.mediaRights = Rights(media?.mediaRights)
            self.mediaScenes = media?.mediaScenes?.map { Scene($0) }
        }
    }

    init(_ feedItem: FeedKit.RSSFeedItem?) {
        self.title = feedItem?.title
        self.link = feedItem?.link
        self.itemDescription = feedItem?.description
        self.author = feedItem?.author
        self.categories = feedItem?.categories?.map { Category($0) }
        self.comments = feedItem?.comments
        self.enclosure = Enclosure(feedItem?.enclosure)
        self.guid = GUID(feedItem?.guid)
        self.pubDate = feedItem?.pubDate
        self.source = Source(feedItem?.source)
        self.dublinCore = RSSFeed.DublinCore(feedItem?.dublinCore)
        self.content = Content(feedItem?.content)
        self.itunes = RSSFeed.iTunesNamespace(feedItem?.iTunes)
        self.media = Media(feedItem?.media)
    }
}
