//
//  MediaDetailsModel.swift
//  PhotoOfTheDay
//
//  Created by Shubhajit Chakraborty on 03/11/2021.
//

enum MediaType: String, Decodable {
    case image
    case video
    case unknown
}

struct MediaDetailsModel: Decodable {
    
    let copyright: String?
    let date: String?
    let explanation: String?
    let hdurl: String?
    let mediaType: MediaType?
    let title: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey{
        case copyright
        case date
        case explanation
        case hdurl
        case mediaType = "media_type"
        case title
        case url
    }
}
