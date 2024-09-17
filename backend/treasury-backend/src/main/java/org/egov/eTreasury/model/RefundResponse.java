package org.egov.eTreasury.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;
import org.egov.common.contract.response.ResponseInfo;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class RefundResponse {

    @JsonProperty("ResponseInfo")
    private ResponseInfo responseInfo;

    @JsonProperty("RefundData")
    private RefundData refundData;
}