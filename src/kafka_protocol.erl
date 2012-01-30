%% @doc Parse and generate kafka protocol objects.
%% See https://cwiki.apache.org/confluence/display/KAFKA/Writing+a+Driver+for+Kafka

-module(kafka_protocol).
-author('Knut Nesheim <knutin@gmail.com>').

-export([fetch_request/3, offset_request/3]).
-export([parse_messages/1, parse_offsets/1]).

-define(FETCH, 1).
-define(OFFSETS, 4).


fetch_request(Topic, Offset, MaxSize) ->
    TopicSize = size(Topic),

    RequestSize = 2 + 2 + TopicSize + 4 + 8 + 4,

    <<RequestSize:32/integer,
      ?FETCH:16/integer,
      TopicSize:16/integer,
      Topic/binary,
      0:32/integer,
      Offset:64/integer,
      MaxSize:32/integer>>.


offset_request(Topic, Time, MaxNumber) ->
    TopicSize = size(Topic),
    RequestSize = 2 + 2 + TopicSize + 4 + 8 + 4,
    <<RequestSize:32/integer,
      ?OFFSETS:16/integer,
      TopicSize:16/integer,
      Topic/binary,
      0:32/integer,
      Time:64/integer,
      MaxNumber:32/integer>>.

parse_messages(Bs) ->
    parse_messages(Bs, [], 0).

parse_messages(<<>>, Acc, Size) ->
    {lists:reverse(Acc), Size};

parse_messages(<<L:32/integer, _/binary>> = B, Acc, Size) when size(B) >= L + 4->
    MsgLength = L - 4 - 1,
    <<_:32/integer, 0:8/integer, _Check:32/integer,
      Msg:MsgLength/binary,
      Rest/bitstring>> = B,
    parse_messages(Rest, [Msg | Acc], Size + L + 4);

parse_messages(_B, Acc, Size) ->
    {lists:reverse(Acc), Size}.


parse_offsets(B) ->
    <<_:32/integer, Offsets/binary>> = B,
    parse_offsets(Offsets, []).

parse_offsets(<<>>, Acc) ->
    lists:reverse(Acc);

parse_offsets(B, Acc) ->
    <<Offset:64/integer, Rest/binary>> = B,
    parse_offsets(Rest, [Offset | Acc]).
