//
//  ClassModel.swift
//  Class Tracker
//
//  Created by Trevor Heins on 4/25/17.
//  Copyright © 2017 Trevor Heins. All rights reserved.
//

class ClassModel {
    
    var course: String
    var instrType: String
    var section: String
    var crn: String
    var url: String
    var courseTitle: String
    var meetingTime: String
    var instructor: String
    
    init?(course: String, instrType: String, section: String, crn: String, url: String, courseTitle: String, meetingTime: String, instructor: String) {
        // Initialize stored properties.
        self.course = course
        self.instrType = instrType
        self.section = section
        self.crn = crn
        self.url = url
        self.courseTitle = courseTitle
        self.meetingTime = meetingTime
        self.instructor = instructor
    }
}
