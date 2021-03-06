package com.famelive.api.command.slotmanagement

import com.famelive.api.command.ApiAuthenticationTokenCommand
import com.famelive.api.constant.ApiConstants
import com.famelive.common.command.slotmanagement.EditEventCommand
import grails.validation.Validateable
import org.grails.databinding.BindingFormat

@Validateable
class ApiEditEventCommand extends ApiAuthenticationTokenCommand {
    Long eventId
    String name
    String description
    @BindingFormat(ApiConstants.INPUT_DATE_FORMAT)
    Date startTime
    Long duration
    String imageName
    List<Long> genreIds

    static constraints = {
        eventId nullable: true
        name nullable: true
        description nullable: true
        startTime nullable: true
        duration nullable: true
        imageName nullable: true
        genreIds nullable: true
    }

    @Override
    EditEventCommand toRequestCommand() {
        return new EditEventCommand(id: this?.id, eventId: this?.eventId, name: this?.name, description: this?.description, startTime: this?.startTime, duration: this?.duration, genreIds: this?.genreIds, imageName: this?.imageName)
    }
}
