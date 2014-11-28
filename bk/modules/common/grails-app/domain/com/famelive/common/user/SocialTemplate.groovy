package com.famelive.common.user

import com.famelive.common.enums.usermanagement.SocialAccount

class SocialTemplate {
    SocialAccount socialAccount
    String message

    static constraints = {
        socialAccount nullable: false
        message nullable: false
    }

    static mapping = {
        message type: 'text'
    }
}
