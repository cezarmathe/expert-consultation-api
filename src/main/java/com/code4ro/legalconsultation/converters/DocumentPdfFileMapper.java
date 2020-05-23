package com.code4ro.legalconsultation.converters;

import com.code4ro.legalconsultation.model.dto.DocumentPdfFileDto;
import com.code4ro.legalconsultation.model.persistence.DocumentPdfFile;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface DocumentPdfFileMapper {

    DocumentPdfFileDto map(DocumentPdfFile documentPdfFile);

    DocumentPdfFile map(DocumentPdfFileDto documentPdfFileDto);
}
