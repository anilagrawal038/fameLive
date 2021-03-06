<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name='layout' content='admin'/>
    <title>Notification Template</title>
</head>

<body>
<div class="form-body">
    <h3 class="form-section">Notification Template</h3>

    <div class="portlet box yellow">
        <div class="portlet-title">
            <div class="caption">
                <i class="fa fa-cogs"></i>Template Detail
            </div>

            <div class="tools">
                <a href="javascript:;" class="collapse">
                </a>
            </div>
        </div>

        <div class="portlet-body">
            <div class="table-responsive">
                <table class="table table-striped table-bordered table-hover">
                    <thead>
                    <tr>
                        <th class="col-md-1">S.No.</th>
                        <th class="col-md-3">Template Name</th>
                        <th class="col-md-6">Template Description</th>
                    </tr>
                    </thead>
                    <tbody>
                    <g:if test="${notificationTemplateVo.adminNotificationTemplateDetailDtoList}">
                        <g:each in="${notificationTemplateVo.adminNotificationTemplateDetailDtoList}" status="i"
                                var="notification">
                            <tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
                                <td class="col-md-3">${i + 1}</td>
                                <td class="col-md-3">${notification?.notification}</td>
                                <td class="col-md-6">${notification?.message}</td>
                            </tr>
                        </g:each>
                    </g:if>
                    <g:else>
                        <tr>
                            <td colspan="7">No template found</td>
                        </tr>
                    </g:else>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>