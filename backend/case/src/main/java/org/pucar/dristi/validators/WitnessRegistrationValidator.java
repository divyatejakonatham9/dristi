package org.pucar.dristi.validators;

import org.egov.common.contract.request.RequestInfo;
import org.egov.tracer.model.CustomException;
import org.pucar.dristi.repository.CaseRepository;
import org.pucar.dristi.repository.WitnessRepository;
import org.pucar.dristi.service.IndividualService;
import org.pucar.dristi.web.models.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.ObjectUtils;

import java.util.Collections;
import java.util.List;

@Component
public class WitnessRegistrationValidator {
    @Autowired
    private IndividualService individualService;
    @Autowired
    CaseRepository repository;
    @Autowired
    WitnessRepository witnessRepository;
    public void validateCaseRegistration(WitnessRequest witnessRequest) throws CustomException{
        RequestInfo requestInfo = witnessRequest.getRequestInfo();

        witnessRequest.getWitnesses().forEach(witness -> {
            if(ObjectUtils.isEmpty(witness.getCaseId()))
                throw new CustomException("EG_BT_APP_ERR", "caseId is mandatory for creating witness");
//            if (!individualService.searchIndividual(requestInfo,courtCase.getLitigants().get(0).getIndividualId()))
//                throw new CustomException("INDIVIDUAL_NOT_FOUND","Requested Individual not found or does not exist");
        });
    }
    public Witness validateApplicationExistence(Witness witness) {
        List<Witness> existingApplications = witnessRepository.getApplications(Collections.singletonList(WitnessSearchCriteria.builder().caseId(witness.getCaseId()).build()));
        if(existingApplications.isEmpty()) throw new CustomException("VALIDATION EXCEPTION","Witness Application does not exist");
        return existingApplications.get(0);
    }
}