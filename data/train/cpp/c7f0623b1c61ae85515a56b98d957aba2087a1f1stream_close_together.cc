
#include <stdio.h>
#include <lacewing.h>

void stream_a_close (Lacewing::Stream &, void *)
{
    printf ("Stream A closing\n");
}

void stream_b_close (Lacewing::Stream &, void *)
{
    printf ("Stream B closing\n");
}

int main(int argc, char * argv[])
{
    Lacewing::Pipe * stream_a = new Lacewing::Pipe,
                   * stream_b = new Lacewing::Pipe;

    stream_a->AddHandlerClose (stream_a_close, 0);
    stream_b->AddHandlerClose (stream_b_close, 0);

    stream_a->AddFilterUpstream (*stream_b, true, true);
    
    printf ("OK, Stream B is a filter for Stream A.  Closing Stream B...\n");

    stream_b->Close ();

    printf ("Deleting stream A\n");

    delete stream_a;


    return 0;
}

