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
    var id = UUID()

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
    var items: [Item]? = nil

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

        struct Category: Codable, Sendable, Identifiable {
            var id: String? { text }

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
        self.dublinCore = DublinCore(feed.dublinCore)
        self.syndication = Syndication(feed.syndication)
        self.iTunes = iTunesNamespace(feed.iTunes)
    }

    init() {}
}
