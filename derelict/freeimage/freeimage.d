/*

Boost Software License - Version 1.0 - August 17th, 2003

Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:

The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

*/
module derelict.freeimage.freeimage;

public
{
    import derelict.freeimage.functions;
    import derelict.freeimage.types;
}

private
{
    import derelict.util.loader;
    import derelict.util.system;

    static if(Derelict_OS_Windows)
        enum libNames = "FreeImage.dll";
    else static if(Derelict_OS_Posix)
        enum libNames = "libfreeimage.so,libfreeimage.so.3";
    else
        static assert(0, "Need to implement FreeImage libNames for this operating system.");
}

class DerelictFILoader : SharedLibLoader
{
    protected
    {
        override void loadSymbols()
        {
            // work-around: names in FreeImage.dll are stdcall-mangled on Windows
            void myBindFunc(Func)(ref Func f, string unmangledName)
            {
                static if(Derelict_OS_Windows)
                {
                    import std.typecons;
                    import std.string;
                    import std.typecons;
                    import std.traits;

                    // get type-tuple of parameters
                    ParameterTypeTuple!f params;

                    size_t sizeOfParametersOnStack(A...)(A args)
                    {
                        size_t sum = 0;
                        foreach (arg; args)
                        {
                            sum += arg.sizeof;

                            // align on 32-bit stack stack (TODO detect 64-bits systems)
                            if (sum % 4 != 0)
                                sum += 4 - (sum % 4);
                        }
                        return sum;
                    }
                    unmangledName = format("_%s@%s", unmangledName, sizeOfParametersOnStack(params));
                }
                bindFunc(cast(void**)&f, unmangledName);
            }

            myBindFunc(FreeImage_Initialise, "FreeImage_Initialise");
            myBindFunc(FreeImage_DeInitialise, "FreeImage_DeInitialise");
            myBindFunc(FreeImage_GetVersion, "FreeImage_GetVersion");
            myBindFunc(FreeImage_GetCopyrightMessage, "FreeImage_GetCopyrightMessage");
            myBindFunc(FreeImage_SetOutputMessageStdCall, "FreeImage_SetOutputMessageStdCall");
            myBindFunc(FreeImage_SetOutputMessage, "FreeImage_SetOutputMessage");

            // This one isn't mangled like the rest, likely because of the variable args.
            bindFunc(cast(void**)&FreeImage_OutputMessageProc, "FreeImage_OutputMessageProc");

            myBindFunc(FreeImage_Allocate, "FreeImage_Allocate");
            myBindFunc(FreeImage_AllocateT, "FreeImage_AllocateT");
            myBindFunc(FreeImage_Clone, "FreeImage_Clone");
            myBindFunc(FreeImage_Unload, "FreeImage_Unload");
            myBindFunc(FreeImage_HasPixels, "FreeImage_HasPixels");
            myBindFunc(FreeImage_Load, "FreeImage_Load");
            myBindFunc(FreeImage_LoadU, "FreeImage_LoadU");
            myBindFunc(FreeImage_LoadFromHandle, "FreeImage_LoadFromHandle");
            myBindFunc(FreeImage_Save, "FreeImage_Save");
            myBindFunc(FreeImage_SaveU, "FreeImage_SaveU");
            myBindFunc(FreeImage_SaveToHandle, "FreeImage_SaveToHandle");
            myBindFunc(FreeImage_OpenMemory, "FreeImage_OpenMemory");
            myBindFunc(FreeImage_CloseMemory, "FreeImage_CloseMemory");
            myBindFunc(FreeImage_LoadFromMemory, "FreeImage_LoadFromMemory");
            myBindFunc(FreeImage_SaveToMemory, "FreeImage_SaveToMemory");
            myBindFunc(FreeImage_TellMemory, "FreeImage_TellMemory");
            myBindFunc(FreeImage_SeekMemory, "FreeImage_SeekMemory");
            myBindFunc(FreeImage_AcquireMemory, "FreeImage_AcquireMemory");
            myBindFunc(FreeImage_ReadMemory, "FreeImage_ReadMemory");
            myBindFunc(FreeImage_WriteMemory, "FreeImage_WriteMemory");
            myBindFunc(FreeImage_LoadMultiBitmapFromMemory, "FreeImage_LoadMultiBitmapFromMemory");
            myBindFunc(FreeImage_SaveMultiBitmapToMemory, "FreeImage_SaveMultiBitmapToMemory");
            myBindFunc(FreeImage_RegisterLocalPlugin, "FreeImage_RegisterLocalPlugin");

            static if (Derelict_OS_Windows)
                myBindFunc(FreeImage_RegisterExternalPlugin, "FreeImage_RegisterExternalPlugin");

            myBindFunc(FreeImage_GetFIFCount, "FreeImage_GetFIFCount");
            myBindFunc(FreeImage_SetPluginEnabled, "FreeImage_SetPluginEnabled");
            myBindFunc(FreeImage_IsPluginEnabled, "FreeImage_IsPluginEnabled");
            myBindFunc(FreeImage_GetFIFFromFormat, "FreeImage_GetFIFFromFormat");
            myBindFunc(FreeImage_GetFIFFromMime, "FreeImage_GetFIFFromMime");
            myBindFunc(FreeImage_GetFormatFromFIF, "FreeImage_GetFormatFromFIF");
            myBindFunc(FreeImage_GetFIFExtensionList, "FreeImage_GetFIFExtensionList");
            myBindFunc(FreeImage_GetFIFDescription, "FreeImage_GetFIFDescription");
            myBindFunc(FreeImage_GetFIFRegExpr, "FreeImage_GetFIFRegExpr");
            myBindFunc(FreeImage_GetFIFMimeType, "FreeImage_GetFIFMimeType");
            myBindFunc(FreeImage_GetFIFFromFilename, "FreeImage_GetFIFFromFilename");
            myBindFunc(FreeImage_GetFIFFromFilenameU, "FreeImage_GetFIFFromFilenameU");
            myBindFunc(FreeImage_FIFSupportsReading, "FreeImage_FIFSupportsReading");
            myBindFunc(FreeImage_FIFSupportsWriting, "FreeImage_FIFSupportsWriting");
            myBindFunc(FreeImage_FIFSupportsExportBPP, "FreeImage_FIFSupportsExportBPP");
            myBindFunc(FreeImage_FIFSupportsExportType, "FreeImage_FIFSupportsExportType");
            myBindFunc(FreeImage_FIFSupportsICCProfiles, "FreeImage_FIFSupportsICCProfiles");
            myBindFunc(FreeImage_FIFSupportsNoPixels, "FreeImage_FIFSupportsNoPixels");
            myBindFunc(FreeImage_OpenMultiBitmap, "FreeImage_OpenMultiBitmap");
            myBindFunc(FreeImage_OpenMultiBitmapFromHandle, "FreeImage_OpenMultiBitmapFromHandle");
            myBindFunc(FreeImage_SaveMultiBitmapToHandle, "FreeImage_SaveMultiBitmapToHandle");
            myBindFunc(FreeImage_CloseMultiBitmap, "FreeImage_CloseMultiBitmap");
            myBindFunc(FreeImage_GetPageCount, "FreeImage_GetPageCount");
            myBindFunc(FreeImage_AppendPage, "FreeImage_AppendPage");
            myBindFunc(FreeImage_InsertPage, "FreeImage_InsertPage");
            myBindFunc(FreeImage_DeletePage, "FreeImage_DeletePage");
            myBindFunc(FreeImage_LockPage, "FreeImage_LockPage");
            myBindFunc(FreeImage_UnlockPage, "FreeImage_UnlockPage");
            myBindFunc(FreeImage_MovePage, "FreeImage_MovePage");
            myBindFunc(FreeImage_GetLockedPageNumbers, "FreeImage_GetLockedPageNumbers");
            myBindFunc(FreeImage_GetFileType, "FreeImage_GetFileType");
            myBindFunc(FreeImage_GetFileTypeU, "FreeImage_GetFileTypeU");
            myBindFunc(FreeImage_GetFileTypeFromHandle, "FreeImage_GetFileTypeFromHandle");
            myBindFunc(FreeImage_GetFileTypeFromMemory, "FreeImage_GetFileTypeFromMemory");
            myBindFunc(FreeImage_GetImageType, "FreeImage_GetImageType");
            myBindFunc(FreeImage_IsLittleEndian, "FreeImage_IsLittleEndian");
            myBindFunc(FreeImage_LookupX11Color, "FreeImage_LookupX11Color");
            myBindFunc(FreeImage_LookupSVGColor, "FreeImage_LookupSVGColor");
            myBindFunc(FreeImage_GetBits, "FreeImage_GetBits");
            myBindFunc(FreeImage_GetScanLine, "FreeImage_GetScanLine");
            myBindFunc(FreeImage_GetPixelIndex, "FreeImage_GetPixelIndex");
            myBindFunc(FreeImage_GetPixelColor, "FreeImage_GetPixelColor");
            myBindFunc(FreeImage_SetPixelIndex, "FreeImage_SetPixelIndex");
            myBindFunc(FreeImage_SetPixelColor, "FreeImage_SetPixelColor");
            myBindFunc(FreeImage_GetColorsUsed, "FreeImage_GetColorsUsed");
            myBindFunc(FreeImage_GetBPP, "FreeImage_GetBPP");
            myBindFunc(FreeImage_GetWidth, "FreeImage_GetWidth");
            myBindFunc(FreeImage_GetHeight, "FreeImage_GetHeight");
            myBindFunc(FreeImage_GetLine, "FreeImage_GetLine");
            myBindFunc(FreeImage_GetPitch, "FreeImage_GetPitch");
            myBindFunc(FreeImage_GetDIBSize, "FreeImage_GetDIBSize");
            myBindFunc(FreeImage_GetPalette, "FreeImage_GetPalette");
            myBindFunc(FreeImage_GetDotsPerMeterX, "FreeImage_GetDotsPerMeterX");
            myBindFunc(FreeImage_GetDotsPerMeterY, "FreeImage_GetDotsPerMeterY");
            myBindFunc(FreeImage_SetDotsPerMeterX, "FreeImage_SetDotsPerMeterX");
            myBindFunc(FreeImage_SetDotsPerMeterY, "FreeImage_SetDotsPerMeterY");
            myBindFunc(FreeImage_GetInfoHeader, "FreeImage_GetInfoHeader");
            myBindFunc(FreeImage_GetInfo, "FreeImage_GetInfo");
            myBindFunc(FreeImage_GetColorType, "FreeImage_GetColorType");
            myBindFunc(FreeImage_GetRedMask, "FreeImage_GetRedMask");
            myBindFunc(FreeImage_GetGreenMask, "FreeImage_GetGreenMask");
            myBindFunc(FreeImage_GetBlueMask, "FreeImage_GetBlueMask");
            myBindFunc(FreeImage_GetTransparencyCount, "FreeImage_GetTransparencyCount");
            myBindFunc(FreeImage_GetTransparencyTable, "FreeImage_GetTransparencyTable");
            myBindFunc(FreeImage_SetTransparent, "FreeImage_SetTransparent");
            myBindFunc(FreeImage_SetTransparencyTable, "FreeImage_SetTransparencyTable");
            myBindFunc(FreeImage_IsTransparent, "FreeImage_IsTransparent");
            myBindFunc(FreeImage_SetTransparentIndex, "FreeImage_SetTransparentIndex");
            myBindFunc(FreeImage_GetTransparentIndex, "FreeImage_GetTransparentIndex");
            myBindFunc(FreeImage_HasBackgroundColor, "FreeImage_HasBackgroundColor");
            myBindFunc(FreeImage_GetBackgroundColor, "FreeImage_GetBackgroundColor");
            myBindFunc(FreeImage_SetBackgroundColor, "FreeImage_SetBackgroundColor");
            myBindFunc(FreeImage_GetThumbnail, "FreeImage_GetThumbnail");
            myBindFunc(FreeImage_SetThumbnail, "FreeImage_SetThumbnail");
            myBindFunc(FreeImage_GetICCProfile, "FreeImage_GetICCProfile");
            myBindFunc(FreeImage_CreateICCProfile, "FreeImage_CreateICCProfile");
            myBindFunc(FreeImage_DestroyICCProfile, "FreeImage_DestroyICCProfile");
            myBindFunc(FreeImage_ConvertLine1To4, "FreeImage_ConvertLine1To4");
            myBindFunc(FreeImage_ConvertLine8To4, "FreeImage_ConvertLine8To4");
            myBindFunc(FreeImage_ConvertLine16To4_555, "FreeImage_ConvertLine16To4_555");
            myBindFunc(FreeImage_ConvertLine16To4_565, "FreeImage_ConvertLine16To4_565");
            myBindFunc(FreeImage_ConvertLine24To4, "FreeImage_ConvertLine24To4");
            myBindFunc(FreeImage_ConvertLine32To4, "FreeImage_ConvertLine32To4");
            myBindFunc(FreeImage_ConvertLine1To8, "FreeImage_ConvertLine1To8");
            myBindFunc(FreeImage_ConvertLine4To8, "FreeImage_ConvertLine4To8");
            myBindFunc(FreeImage_ConvertLine16To8_555, "FreeImage_ConvertLine16To8_555");
            myBindFunc(FreeImage_ConvertLine16To8_565, "FreeImage_ConvertLine16To8_565");
            myBindFunc(FreeImage_ConvertLine24To8, "FreeImage_ConvertLine24To8");
            myBindFunc(FreeImage_ConvertLine32To8, "FreeImage_ConvertLine32To8");
            myBindFunc(FreeImage_ConvertLine1To16_555, "FreeImage_ConvertLine1To16_555");
            myBindFunc(FreeImage_ConvertLine4To16_555, "FreeImage_ConvertLine4To16_555");
            myBindFunc(FreeImage_ConvertLine8To16_555, "FreeImage_ConvertLine8To16_555");
            myBindFunc(FreeImage_ConvertLine16_565_To16_555, "FreeImage_ConvertLine16_565_To16_555");
            myBindFunc(FreeImage_ConvertLine24To16_555, "FreeImage_ConvertLine24To16_555");
            myBindFunc(FreeImage_ConvertLine32To16_555, "FreeImage_ConvertLine32To16_555");
            myBindFunc(FreeImage_ConvertLine1To16_565, "FreeImage_ConvertLine1To16_565");
            myBindFunc(FreeImage_ConvertLine4To16_565, "FreeImage_ConvertLine4To16_565");
            myBindFunc(FreeImage_ConvertLine8To16_565, "FreeImage_ConvertLine8To16_565");
            myBindFunc(FreeImage_ConvertLine16_555_To16_565, "FreeImage_ConvertLine16_555_To16_565");
            myBindFunc(FreeImage_ConvertLine24To16_565, "FreeImage_ConvertLine24To16_565");
            myBindFunc(FreeImage_ConvertLine32To16_565, "FreeImage_ConvertLine32To16_565");
            myBindFunc(FreeImage_ConvertLine1To24, "FreeImage_ConvertLine1To24");
            myBindFunc(FreeImage_ConvertLine4To24, "FreeImage_ConvertLine4To24");
            myBindFunc(FreeImage_ConvertLine8To24, "FreeImage_ConvertLine8To24");
            myBindFunc(FreeImage_ConvertLine16To24_555, "FreeImage_ConvertLine16To24_555");
            myBindFunc(FreeImage_ConvertLine16To24_565, "FreeImage_ConvertLine16To24_565");
            myBindFunc(FreeImage_ConvertLine32To24, "FreeImage_ConvertLine32To24");
            myBindFunc(FreeImage_ConvertLine1To32, "FreeImage_ConvertLine1To32");
            myBindFunc(FreeImage_ConvertLine4To32, "FreeImage_ConvertLine4To32");
            myBindFunc(FreeImage_ConvertLine8To32, "FreeImage_ConvertLine8To32");
            myBindFunc(FreeImage_ConvertLine16To32_555, "FreeImage_ConvertLine16To32_555");
            myBindFunc(FreeImage_ConvertLine16To32_565, "FreeImage_ConvertLine16To32_565");
            myBindFunc(FreeImage_ConvertLine24To32, "FreeImage_ConvertLine24To32");
            myBindFunc(FreeImage_ConvertTo4Bits, "FreeImage_ConvertTo4Bits");
            myBindFunc(FreeImage_ConvertTo8Bits, "FreeImage_ConvertTo8Bits");
            myBindFunc(FreeImage_ConvertToGreyscale, "FreeImage_ConvertToGreyscale");
            myBindFunc(FreeImage_ConvertTo16Bits555, "FreeImage_ConvertTo16Bits555");
            myBindFunc(FreeImage_ConvertTo16Bits565, "FreeImage_ConvertTo16Bits565");
            myBindFunc(FreeImage_ConvertTo24Bits, "FreeImage_ConvertTo24Bits");
            myBindFunc(FreeImage_ConvertTo32Bits, "FreeImage_ConvertTo32Bits");
            myBindFunc(FreeImage_ColorQuantize, "FreeImage_ColorQuantize");
            myBindFunc(FreeImage_ColorQuantizeEx, "FreeImage_ColorQuantizeEx");
            myBindFunc(FreeImage_Threshold, "FreeImage_Threshold");
            myBindFunc(FreeImage_Dither, "FreeImage_Dither");
            myBindFunc(FreeImage_ConvertFromRawBits, "FreeImage_ConvertFromRawBits");
            myBindFunc(FreeImage_ConvertToRawBits, "FreeImage_ConvertToRawBits");
            myBindFunc(FreeImage_ConvertToFloat, "FreeImage_ConvertToFloat");
            myBindFunc(FreeImage_ConvertToRGBF, "FreeImage_ConvertToRGBF");
            myBindFunc(FreeImage_ConvertToUINT16, "FreeImage_ConvertToUINT16");
            myBindFunc(FreeImage_ConvertToRGB16, "FreeImage_ConvertToRGB16");
            myBindFunc(FreeImage_ConvertToStandardType, "FreeImage_ConvertToStandardType");
            myBindFunc(FreeImage_ConvertToType, "FreeImage_ConvertToType");
            myBindFunc(FreeImage_ToneMapping, "FreeImage_ToneMapping");
            myBindFunc(FreeImage_TmoDrago03, "FreeImage_TmoDrago03");
            myBindFunc(FreeImage_TmoReinhard05, "FreeImage_TmoReinhard05");
            myBindFunc(FreeImage_TmoReinhard05Ex, "FreeImage_TmoReinhard05Ex");
            myBindFunc(FreeImage_TmoFattal02, "FreeImage_TmoFattal02");
            myBindFunc(FreeImage_ZLibCompress, "FreeImage_ZLibCompress");
            myBindFunc(FreeImage_ZLibUncompress, "FreeImage_ZLibUncompress");
            myBindFunc(FreeImage_ZLibGZip, "FreeImage_ZLibGZip");
            myBindFunc(FreeImage_ZLibGUnzip, "FreeImage_ZLibGUnzip");
            myBindFunc(FreeImage_ZLibCRC32, "FreeImage_ZLibCRC32");

            myBindFunc(FreeImage_CreateTag, "FreeImage_CreateTag");
            myBindFunc(FreeImage_DeleteTag, "FreeImage_DeleteTag");
            myBindFunc(FreeImage_CloneTag, "FreeImage_CloneTag");
            myBindFunc(FreeImage_GetTagKey, "FreeImage_GetTagKey");
            myBindFunc(FreeImage_GetTagDescription, "FreeImage_GetTagDescription");
            myBindFunc(FreeImage_GetTagID, "FreeImage_GetTagID");
            myBindFunc(FreeImage_GetTagType, "FreeImage_GetTagType");
            myBindFunc(FreeImage_GetTagCount, "FreeImage_GetTagCount");
            myBindFunc(FreeImage_GetTagLength, "FreeImage_GetTagLength");
            myBindFunc(FreeImage_GetTagValue, "FreeImage_GetTagValue");
            myBindFunc(FreeImage_SetTagKey, "FreeImage_SetTagKey");
            myBindFunc(FreeImage_SetTagDescription, "FreeImage_SetTagDescription");
            myBindFunc(FreeImage_SetTagID, "FreeImage_SetTagID");
            myBindFunc(FreeImage_SetTagType, "FreeImage_SetTagType");
            myBindFunc(FreeImage_SetTagCount, "FreeImage_SetTagCount");
            myBindFunc(FreeImage_SetTagLength, "FreeImage_SetTagLength");
            myBindFunc(FreeImage_SetTagValue, "FreeImage_SetTagValue");
            myBindFunc(FreeImage_FindFirstMetadata, "FreeImage_FindFirstMetadata");
            myBindFunc(FreeImage_FindNextMetadata, "FreeImage_FindNextMetadata");
            myBindFunc(FreeImage_FindCloseMetadata, "FreeImage_FindCloseMetadata");
            myBindFunc(FreeImage_GetMetadata, "FreeImage_GetMetadata");
            myBindFunc(FreeImage_SetMetadata, "FreeImage_SetMetadata");
            myBindFunc(FreeImage_GetMetadataCount, "FreeImage_GetMetadataCount");
            myBindFunc(FreeImage_CloneMetadata, "FreeImage_CloneMetadata");
            myBindFunc(FreeImage_TagToString, "FreeImage_TagToString");

            myBindFunc(FreeImage_RotateClassic, "FreeImage_RotateClassic");
            myBindFunc(FreeImage_Rotate, "FreeImage_Rotate");
            myBindFunc(FreeImage_RotateEx, "FreeImage_RotateEx");
            myBindFunc(FreeImage_FlipHorizontal, "FreeImage_FlipHorizontal");
            myBindFunc(FreeImage_FlipVertical, "FreeImage_FlipVertical");
            myBindFunc(FreeImage_JPEGTransform, "FreeImage_JPEGTransform");
            myBindFunc(FreeImage_JPEGTransformU, "FreeImage_JPEGTransformU");
            myBindFunc(FreeImage_Rescale, "FreeImage_Rescale");
            myBindFunc(FreeImage_MakeThumbnail, "FreeImage_MakeThumbnail");
            myBindFunc(FreeImage_AdjustCurve, "FreeImage_AdjustCurve");
            myBindFunc(FreeImage_AdjustGamma, "FreeImage_AdjustGamma");
            myBindFunc(FreeImage_AdjustBrightness, "FreeImage_AdjustBrightness");
            myBindFunc(FreeImage_AdjustContrast, "FreeImage_AdjustContrast");
            myBindFunc(FreeImage_Invert, "FreeImage_Invert");
            myBindFunc(FreeImage_GetHistogram, "FreeImage_GetHistogram");
            myBindFunc(FreeImage_GetAdjustColorsLookupTable, "FreeImage_GetAdjustColorsLookupTable");
            myBindFunc(FreeImage_AdjustColors, "FreeImage_AdjustColors");
            myBindFunc(FreeImage_ApplyColorMapping, "FreeImage_ApplyColorMapping");
            myBindFunc(FreeImage_SwapColors, "FreeImage_SwapColors");
            myBindFunc(FreeImage_ApplyPaletteIndexMapping, "FreeImage_ApplyPaletteIndexMapping");
            myBindFunc(FreeImage_SwapPaletteIndices, "FreeImage_SwapPaletteIndices");
            myBindFunc(FreeImage_GetChannel, "FreeImage_GetChannel");
            myBindFunc(FreeImage_SetChannel, "FreeImage_SetChannel");
            myBindFunc(FreeImage_GetComplexChannel, "FreeImage_GetComplexChannel");
            myBindFunc(FreeImage_SetComplexChannel, "FreeImage_SetComplexChannel");
            myBindFunc(FreeImage_Copy, "FreeImage_Copy");
            myBindFunc(FreeImage_Paste, "FreeImage_Paste");
            myBindFunc(FreeImage_Composite, "FreeImage_Composite");
            myBindFunc(FreeImage_JPEGCrop, "FreeImage_JPEGCrop");
            myBindFunc(FreeImage_JPEGCropU, "FreeImage_JPEGCropU");
            myBindFunc(FreeImage_PreMultiplyWithAlpha, "FreeImage_PreMultiplyWithAlpha");
            myBindFunc(FreeImage_FillBackground, "FreeImage_FillBackground");
            myBindFunc(FreeImage_EnlargeCanvas, "FreeImage_EnlargeCanvas");
            myBindFunc(FreeImage_AllocateEx, "FreeImage_AllocateEx");
            myBindFunc(FreeImage_AllocateExT, "FreeImage_AllocateExT");
            myBindFunc(FreeImage_MultigridPoissonSolver, "FreeImage_MultigridPoissonSolver");
        }
    }

    public
    {
        this()
        {
            super(libNames);
        }
    }
}

__gshared DerelictFILoader DerelictFI;

shared static this()
{
    DerelictFI = new DerelictFILoader();
}

shared static ~this()
{
    DerelictFI.unload();
}
