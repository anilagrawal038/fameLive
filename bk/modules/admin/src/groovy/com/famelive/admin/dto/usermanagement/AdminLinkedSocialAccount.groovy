package com.famelive.admin.dto.usermanagement

import com.famelive.admin.dto.AdminResponseDto
import com.famelive.common.user.LinkedSocialAccount

class AdminLinkedSocialAccount extends AdminResponseDto{
    String socialAccount
    String token

    AdminLinkedSocialAccount() {}

    AdminLinkedSocialAccount(LinkedSocialAccount linkedSocialAccount) {
        this.socialAccount = linkedSocialAccount.socialAccount
        this.token = linkedSocialAccount.token ?: ""
    }

    static AdminLinkedSocialAccount createApiResponseDto(LinkedSocialAccount linkedSocialAccount) {
        return new AdminLinkedSocialAccount(linkedSocialAccount)
    }
}
