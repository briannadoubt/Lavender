//
//  Item.swift
//  Lavender
//
//  Created by Brianna Zamora on 4/6/24.
//

import Foundation
import SwiftData
import FeedKit

@Model
class Item {
    var id = UUID()

    var progress: Float = 0

    var currentlyPlaying: CurrentlyPlaying?

    @Relationship(inverse: \RSSFeed.items)
    var feed: RSSFeed? = nil

    /// The title of the item.
    ///
    /// Example: Venice Film Festival Tries to Quit Sinking
    public var title: String? = nil

    /// The URL of the item.
    ///
    /// Example: http://nytimes.com/2004/12/07FEST.html
    public var link: String? = nil

    /// The item synopsis.
    ///
    /// Example: Some of the most heated chatter at the Venice Film Festival this
    /// week was about the way that the arrival of the stars at the Palazzo del
    /// Cinema was being staged.
    public var itemDescription: String? = nil

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
    public var author: String? = nil

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
    public var categories: [Category]? = nil

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
    public var comments: String? = nil

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
    public var enclosure: Enclosure? = nil

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
    public var guid: GUID? = nil

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
    public var pubDate: Date? = nil

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
    public var source: Source? = nil

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
    public var dublinCore: RSSFeed.DublinCore? = nil

    /// A module for the actual content of websites, in multiple formats.
    ///
    /// See http://web.resource.org/rss/1.0/modules/content/
    public var content: Content? = nil

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
    public var itunes: RSSFeed.iTunesNamespace? = nil

    /// Media RSS is a new RSS module that supplements the <enclosure>
    /// capabilities of RSS 2.0.
    public var media: Media? = nil

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

        struct Content: Codable, Sendable, Identifiable {
            var id: String? { url }

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
        public var mediaContents: [Content]? = nil

        /// This allows the permissible audience to be declared. If this element is not
        /// included, it assumes that no restrictions are necessary. It has one
        /// optional attribute.
        public var mediaRating: Rating? = nil

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
        public var mediaTitle: Title? = nil

        /// Short description describing the media object typically a sentence in
        /// length. It has one optional attribute.
        public var mediaDescription: Description? = nil

        /// Highly relevant keywords describing the media object with typically a
        /// maximum of 10 words. The keywords and phrases should be comma-delimited.
        public var mediaKeywords: [String]? = nil

        /// Allows particular images to be used as representative images for the
        /// media object. If multiple thumbnails are included, and time coding is not
        /// at play, it is assumed that the images are in order of importance. It has
        /// one required attribute and three optional attributes.
        public var mediaThumbnails: [Thumbnail]? = nil

        /// Allows a taxonomy to be set that gives an indication of the type of media
        /// content, and its particular contents. It has two optional attributes.
        public var mediaCategory: Category? = nil

        /// This is the hash of the binary media file. It can appear multiple times as
        /// long as each instance is a different algo. It has one optional attribute.
        public var mediaHash: Hash? = nil

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
        public var mediaPlayer: Player? = nil

        /// Notable entity and the contribution to the creation of the media object.
        /// Current entities can include people, companies, locations, etc. Specific
        /// entities can have multiple roles, and several entities can have the same
        /// role. These should appear as distinct <media:credit> elements. It has two
        /// optional attributes.
        public var mediaCredits: [Credit]? = nil

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
        public var mediaCopyright: Copyright? = nil

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
        public var mediaText: Text? = nil

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
        public var mediaRestriction: Restriction? = nil

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
        public var mediaCommunity: Community? = nil

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

        struct Tag: Codable, Sendable, Identifiable {
            var id: String? { tag }
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
