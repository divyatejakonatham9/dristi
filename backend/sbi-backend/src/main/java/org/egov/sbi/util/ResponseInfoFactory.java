package org.egov.sbi.util;

import org.egov.common.contract.request.RequestInfo;
import org.egov.common.contract.response.ResponseInfo;
import org.egov.sbi.config.ServiceConstants;
import org.springframework.stereotype.Component;

@Component
public class ResponseInfoFactory {

    public ResponseInfo createResponseInfoFromRequestInfo(final RequestInfo requestInfo, final boolean success) {

        final String apiId = requestInfo != null ? requestInfo.getApiId() : "";
        final String ver = requestInfo != null ? requestInfo.getVer() : "";
        Long ts = null;
        if(requestInfo!=null)
            ts = requestInfo.getTs();
        final String resMsgId = ServiceConstants.RES_MSG_ID; // FIXME : Hard-coded
        final String msgId = requestInfo != null ? requestInfo.getMsgId() : "";
        final String responseStatus = success ? ServiceConstants.SUCCESSFUL : ServiceConstants.FAILED;

        return ResponseInfo.builder().apiId(apiId).ver(ver).ts(ts).resMsgId(resMsgId).msgId(msgId).resMsgId(resMsgId)
                .status(responseStatus).build();
    }

}