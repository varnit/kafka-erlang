%% @doc Parse and generate kafka protocol objects.
%% See https://cwiki.apache.org/confluence/display/KAFKA/Writing+a+Driver+for+Kafka

-module(kafka_protocol).
-author('Knut Nesheim <knutin@gmail.com>').

-export([fetch_request/3, parse_messages/1]).

-define(FETCH, 1).


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



parse_messages(Bs) ->
    parse_messages(Bs, [], 0).

parse_messages(<<>>, Acc, Size) ->
    {lists:reverse(Acc), Size};

parse_messages(<<L:32/integer, _/binary>> = B, Acc, Size) when size(B) >= L - 1 - 4->
    Length = L - 4 - 1,
    <<_:32/integer, 0:8/integer, _Check:32/integer,
      Msg:Length/binary,
      Rest/bitstring>> = B,
    parse_messages(Rest, [Msg | Acc], Size + Length + 4 + 1 + 4);

parse_messages(_B, Acc, Size) ->
    {lists:reverse(Acc), Size}.


