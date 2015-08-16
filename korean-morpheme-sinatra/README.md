## Korean Morpheme Sinatra

### Usage

  * GET or POST `/morpheme`
  * params
    * `text` : text
    * `posids` : return a matching posid, seperated by ','

#### Result

```json
{
  "morps": [
    {
      "surface": "눈",
      "posid": 150,
      "desc": "일반 명사",
      "feature": "NNG,*,T,눈,*,*,*,*"
    },
    {
      "surface": "마사지기",
      "posid": 151,
      "desc": "고유 명사",
      "feature": "NNP,*,F,마사지기,*,*,*,*"
    },
    {
      "surface": "사요",
      "posid": 150,
      "desc": "일반 명사",
      "feature": "NNG,*,F,사요,*,*,*,*"
    }
  ]
}

```

### Docker Start

  docker run -it --rm -p 4567:4567 n42corp/korean-morpheme-sinatra

### Build

  touch cache-buster && docker build -t n42corp/korean-morpheme-sinatra .

`cache-buster` for latest user dic

https://github.com/docker/docker/pull/10682#issuecomment-73777340

