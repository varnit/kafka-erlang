-module(kafka_protocol_tests).
-include_lib("eunit/include/eunit.hrl").

parse_messages_test() ->
    B = <<0,0,0,20,0,203,100,194,139,115,97,111,101,116,117,104,97,115,110,111,
        101,116,104,117,0,0,0,54,0,252,76,192,247,97,115,111,110,101,117,104,
        97,110,115,111,101,32,117,104,97,110,115,111,101,116,117,32,104,97,111,
        110,115,101,117,104,116,32,97,111,110,115,101,117,104,116,32,97,111,
        115,101,110,117,116>>,
    M = kafka_protocol:parse_messages(B),
    ?assertEqual([<<"saoetuhasnoethu">>,
                  <<"asoneuhansoe uhansoetu haonseuht aonseuht aosenut">>], M).

%% split_data_test() ->
%%     B1 = <<0,0,0,20,0,203,100,194,139,115,97,111,101,116,117,104,97,115,110,111,
%%            101,116,104,117,0,0,0,54,0,252,76,192,247,97,115,111,110,101,117,104>>,
%%     B2 = <<97,110,115,111,101,32,117,104,97,110,115,111,101,116,117,32,104,97,111,
%%            110,115,101,117,104,116,32,97,111,110,115,101,117,104,116,32,97,111,
%%            115,101,110,117,116>>,

%%     {M1, R1} = kafka_parser:parse_messages(B1),
%%     ?assertEqual([<<"saoetuhasnoethu">>], M1),
%%     ?assertEqual(R1,<<0,0,0,54,0,252,76,192,247,97,115,111,110,101,117,104>>),

%%     {M2, R2} = kafka_parser:parse_messages(<<R1/binary, B2/binary>>),
%%     ?assertEqual([<<"asoneuhansoe uhansoetu haonseuht aonseuht aosenut">>], M2),
%%     ?assertEqual(<<>>, R2).
