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
module derelict.alure.functions;

private
{
    import derelict.openal.types;
    import derelict.alure.types;
}

extern(C) nothrow
{
    alias void* function(ALchar*) alureInstallDecodeCallbacks_open_file;
    alias void* function(ALubyte*, ALuint) alureInstallDecodeCallbacks_open_memory;
    alias ALboolean function(void*, ALenum*, ALuint*, ALuint*) alureInstallDecodeCallbacks_get_format;
    alias ALuint function(void*, ALubyte*, ALuint) alureInstallDecodeCallbacks_decode;
    alias ALboolean function(void*) alureInstallDecodeCallbacks_rewind;
    alias void function(void*) alureInstallDecodeCallbacks_close;

    alias ALuint function(void*, ALubyte*, ALuint) alureCreateStreamFromCallback_callback;

    alias void* function(char*, ALuint) alureSetIOCallbacks_open_callback;
    alias void function(char*) alureSetIOCallbacks_close_callback;
    alias ALsizei function(void*, ALubyte*, ALuint) alureSetIOCallbacks_read_callback;
    alias ALsizei function(void*, ALubyte*, ALuint) alureSetIOCallbacks_write_callback;
    alias alureInt64 function(void*, alureInt64, int) alureSetIOCallbacks_seek_callback;

    alias void function(void*, ALuint) alurePlaySourceStream_eos_callback;
    alias void function(void*, ALuint) alurePlaySource_callback;
}

extern(C)
{
    alias nothrow void function(ALuint*, ALuint*) da_alureGetVersion;
    alias nothrow ALchar* function() da_alureGetErrorString;
    alias nothrow ALCchar** function(ALCboolean all, ALCsizei*) da_alureGetDeviceNames;
    alias nothrow void function(ALCchar**) da_alureFreeDeviceNames;
    alias nothrow ALCboolean function(ALCchar*, ALCint*) da_alureInitDevice;
    alias nothrow ALCboolean function() da_alureShutdownDevice;
    alias nothrow ALenum function(ALuint, ALuint, ALuint) da_alureGetSampleFormat;
    alias nothrow ALboolean function(ALint,
            alureInstallDecodeCallbacks_open_file,
            alureInstallDecodeCallbacks_open_memory,
            alureInstallDecodeCallbacks_get_format,
            alureInstallDecodeCallbacks_decode,
            alureInstallDecodeCallbacks_rewind,
            alureInstallDecodeCallbacks_close) da_alureInstallDecodeCallbacks;
    alias nothrow ALboolean function(ALfloat) da_alureSleep;
    alias nothrow void* function(ALchar*) da_alureGetProcAddress;

    alias nothrow ALuint function(ALchar*) da_alureCreateBufferFromFile;
    alias nothrow ALuint function(ALubyte*, ALsizei) da_alureCreateBufferFromMemory;
    alias nothrow ALboolean function(ALchar*, ALuint) da_alureBufferDataFromFile;
    alias nothrow ALboolean function(ALubyte*, ALsizei, ALuint) da_alureBufferDataFromMemory;

    alias nothrow ALboolean function(ALboolean) da_alureStreamSizeIsMicroSec;
    alias nothrow alureStream* function(ALchar*, ALsizei, ALsizei, ALuint*) da_alureCreateStreamFromFile;
    alias nothrow alureStream* function(ALubyte*, ALuint, ALsizei, ALsizei, ALuint*) da_alureCreateStreamFromMemory;
    alias nothrow alureStream* function(ALubyte*, ALuint, ALsizei, ALsizei, ALuint*) da_alureCreateStreamFromStaticMemory;
    alias nothrow alureStream* function(alureCreateStreamFromCallback_callback,
                                        void*, ALenum, ALuint, ALsizei, ALsizei, ALuint*) da_alureCreateStreamFromCallback;
    alias nothrow ALsizei function(alureStream*) da_alureGetStreamFrequency;
    alias nothrow ALsizei function(alureStream*, ALsizei, ALuint*) da_alureBufferDataFromStream;
    alias nothrow ALboolean function(alureStream*, ALsizei) da_alureRewindStream;
    alias nothrow ALboolean function(alureStream*, ALuint) da_alureSetStreamOrder;
    alias nothrow ALboolean function(alureStream*, ALchar*) da_alureSetStreamPatchset;
    alias nothrow alureInt64 function(alureStream*) da_alureGetStreamLength;
    alias nothrow ALboolean function(alureStream*, ALsizei, ALsizei, ALuint*) da_alureDestroyStream;

    alias nothrow ALboolean function(alureSetIOCallbacks_open_callback,
                                     alureSetIOCallbacks_close_callback,
                                     alureSetIOCallbacks_read_callback,
                                     alureSetIOCallbacks_write_callback,
                                     alureSetIOCallbacks_seek_callback) da_alureSetIOCallbacks;

    alias nothrow ALboolean function(ALuint, alureStream*, ALsizei, ALsizei, alurePlaySourceStream_eos_callback, void*) da_alurePlaySourceStream;
    alias nothrow ALboolean function(ALuint, alurePlaySource_callback, void*) da_alurePlaySource;
    alias nothrow ALboolean function(ALuint, ALboolean) da_alureStopSource;
    alias nothrow ALboolean function(ALuint) da_alurePauseSource;
    alias nothrow ALboolean function(ALuint) da_alureResumeSource;
    alias nothrow void function() da_alureUpdate;
    alias nothrow ALboolean function(ALfloat) da_alureUpdateInterval;
}

__gshared
{
    da_alureGetVersion alureGetVersion;
    da_alureGetErrorString alureGetErrorString;
    da_alureGetDeviceNames alureGetDeviceNames;
    da_alureFreeDeviceNames alureFreeDeviceNames;
    da_alureInitDevice alureInitDevice;
    da_alureShutdownDevice alureShutdownDevice;
    da_alureGetSampleFormat alureGetSampleFormat;
    da_alureInstallDecodeCallbacks alureInstallDecodeCallbacks;
    da_alureSleep alureSleep;
    da_alureGetProcAddress alureGetProcAddress;

    da_alureCreateBufferFromFile alureCreateBufferFromFile;
    da_alureCreateBufferFromMemory alureCreateBufferFromMemory;
    da_alureBufferDataFromFile alureBufferDataFromFile;
    da_alureBufferDataFromMemory alureBufferDataFromMemory;

    da_alureStreamSizeIsMicroSec alureStreamSizeIsMicroSec ;
    da_alureCreateStreamFromFile alureCreateStreamFromFile;
    da_alureCreateStreamFromMemory alureCreateStreamFromMemory;
    da_alureCreateStreamFromStaticMemory alureCreateStreamFromStaticMemory;
    da_alureCreateStreamFromCallback alureCreateStreamFromCallback;
    da_alureGetStreamFrequency alureGetStreamFrequency;
    da_alureBufferDataFromStream alureBufferDataFromStream;
    da_alureRewindStream alureRewindStream;
    da_alureSetStreamOrder alureSetStreamOrder;
    da_alureSetStreamPatchset alureSetStreamPatchset;
    da_alureGetStreamLength alureGetStreamLength;
    da_alureDestroyStream alureDestroyStream;

    da_alureSetIOCallbacks alureSetIOCallbacks;

    da_alurePlaySourceStream alurePlaySourceStream;
    da_alurePlaySource alurePlaySource;
    da_alureStopSource alureStopSource;
    da_alurePauseSource alurePauseSource;
    da_alureResumeSource alureResumeSource;
    da_alureUpdate alureUpdate;
    da_alureUpdateInterval alureUpdateInterval;
}
