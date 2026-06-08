# Command-line build for the wsdl2objc codegen tool.
#
# Layout:
#   Core/  — shared WSDL parser + model (ObjC)
#   Swift/ — Swift code generation (USSwiftEmitter, SOAPMacros SwiftPM package)
#   ObjC/  — modern ObjC code generation (USModernObjCEmitter, SOAPObjCRuntime SwiftPM package)
#
# Targets:
#   make              -> builds ./build/wsdl2objc
#   make swift        -> regenerate all Swift fixtures + compile against SOAPMacros
#   make objc-modern  -> regenerate all ObjC fixtures + compile against SOAPObjCRuntime
#   make clean

CC      := clang
ROOT    := $(CURDIR)
BUILD   := $(ROOT)/build
BIN     := $(BUILD)/wsdl2objc

# The parser is MRR-era code (retain/release/autorelease, NSAutoreleasePool).
CFLAGS  := -fno-objc-arc -fobjc-exceptions \
           -Wno-deprecated-declarations -Wno-objc-root-class \
           -Wno-incompatible-pointer-types-discards-qualifiers \
           -Wno-format -Wno-shorten-64-to-32 -Wno-bool-conversion \
           -Wno-unused-variable -Wno-receiver-forward-class \
           -Wno-undeclared-selector -Wno-incomplete-implementation \
           -Wno-pointer-bool-conversion -Wno-unused-function \
           -Wno-objc-string-compare -Wno-nullability-completeness

INCLUDES := -I$(ROOT) \
            -I$(ROOT)/Core -I$(ROOT)/Core/Classes -I$(ROOT)/Core/Classes/Types \
            -I$(ROOT)/ObjC -I$(ROOT)/ObjC/Modern \
            -I$(ROOT)/Swift

FRAMEWORKS := -framework Foundation

SOURCES := main.m \
           Core/NSString+USAdditions.m Core/USObjCKeywords.m \
           $(wildcard Core/Classes/*.m) $(wildcard Core/Classes/Types/*.m) \
           Swift/USSwiftEmitter.m \
           ObjC/Modern/USModernObjCEmitter.m

SOAP_MACROS := $(ROOT)/Swift/SOAPMacros
SOAP_OBJC   := $(ROOT)/ObjC/SOAPObjCRuntime

.PHONY: all clean swift swift-temp swift-countries swift-session swift-purchase swift-vies swift-verify \
        objc-modern objc-temp objc-countries objc-session objc-purchase objc-vies objc-verify

all: $(BIN)

$(BIN): $(SOURCES)
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) $(INCLUDES) $(FRAMEWORKS) $(SOURCES) -o $(BIN)

clean:
	rm -rf $(BUILD)

# ----- Swift fixtures -----

swift-temp: $(BIN)
	@mkdir -p $(BUILD)/temp-out
	$(BIN) -wsdlPath $(ROOT)/Swift/Samples/TemperatureConversions/TemperatureConversions.wsdl \
	       -outPath $(BUILD)/temp-out -language swift

swift-countries: $(BIN)
	@mkdir -p $(BUILD)/cinfo-out
	$(BIN) -wsdlPath $(ROOT)/Swift/Samples/CountryInfo/CountryInfoService.wsdl \
	       -outPath $(BUILD)/cinfo-out -language swift

swift-session: $(BIN)
	@mkdir -p $(BUILD)/sess-out
	$(BIN) -wsdlPath $(ROOT)/Swift/Samples/SessionEcho/SessionEcho.wsdl \
	       -outPath $(BUILD)/sess-out -language swift

swift-purchase: $(BIN)
	@mkdir -p $(BUILD)/po-out
	$(BIN) -wsdlPath $(ROOT)/Swift/Samples/PurchaseOrder/PurchaseOrder.wsdl \
	       -outPath $(BUILD)/po-out -language swift

swift-vies: $(BIN)
	@mkdir -p $(BUILD)/vies-out
	$(BIN) -wsdlPath $(ROOT)/Swift/Samples/VIES/checkVatService.wsdl \
	       -outPath $(BUILD)/vies-out -language swift

swift-verify: swift-temp swift-countries swift-session swift-purchase swift-vies
	cp $(BUILD)/temp-out/TemperatureConversions.swift \
	   $(SOAP_MACROS)/Examples/TemperatureConversionsGenerated/TemperatureConversions.swift
	cp $(BUILD)/cinfo-out/CountryInfoService.swift \
	   $(SOAP_MACROS)/Examples/CountryInfoDemo/CountryInfoService.swift
	cp $(BUILD)/sess-out/SessionEcho.swift \
	   $(SOAP_MACROS)/Examples/SessionEchoGenerated/SessionEcho.swift
	cp $(BUILD)/po-out/ListenerServiceService.swift \
	   $(SOAP_MACROS)/Examples/PurchaseOrderGenerated/PurchaseOrder.swift
	cp $(BUILD)/vies-out/checkVatService.swift \
	   $(SOAP_MACROS)/Examples/VIESDemo/checkVatService.swift
	cp $(BUILD)/vies-out/ns1.swift \
	   $(SOAP_MACROS)/Examples/VIESDemo/VIESTypes.swift
	cd $(SOAP_MACROS) && swift build

swift: swift-verify

# ----- Modern ObjC fixtures -----

define objc_modern_fixture
	@mkdir -p $(BUILD)/objc-$(1)
	@rm -f $(BUILD)/objc-$(1)/*.h $(BUILD)/objc-$(1)/*.m
	$(BIN) -wsdlPath $(2) -outPath $(BUILD)/objc-$(1) -language objc-modern
	cp $(BUILD)/objc-$(1)/*.h $(BUILD)/objc-$(1)/*.m $(SOAP_OBJC)/Examples/$(3)/
endef

objc-temp: $(BIN)
	$(call objc_modern_fixture,TemperatureConversions,$(ROOT)/Swift/Samples/TemperatureConversions/TemperatureConversions.wsdl,TemperatureConversionsDemo)

objc-countries: $(BIN)
	$(call objc_modern_fixture,CountryInfo,$(ROOT)/Swift/Samples/CountryInfo/CountryInfoService.wsdl,CountryInfoDemo)

objc-session: $(BIN)
	$(call objc_modern_fixture,SessionEcho,$(ROOT)/Swift/Samples/SessionEcho/SessionEcho.wsdl,SessionEchoDemo)

objc-purchase: $(BIN)
	$(call objc_modern_fixture,PurchaseOrder,$(ROOT)/Swift/Samples/PurchaseOrder/PurchaseOrder.wsdl,PurchaseOrderDemo)

objc-vies: $(BIN)
	$(call objc_modern_fixture,VIES,$(ROOT)/Swift/Samples/VIES/checkVatService.wsdl,VIESDemo)

objc-verify: objc-temp objc-countries objc-session objc-purchase objc-vies
	cd $(SOAP_OBJC) && swift build

objc-modern: objc-verify
