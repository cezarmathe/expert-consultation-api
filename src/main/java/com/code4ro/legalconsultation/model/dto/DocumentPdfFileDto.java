package com.code4ro.legalconsultation.model.dto;

import lombok.Getter;
import lombok.Setter;
import org.joda.time.DateTime;

@Getter
@Setter
public class DocumentPdfFileDto extends BaseEntityDto {
    private String state;
    private String filePath;
    private DateTime timestamp;
    private String hash;
}
