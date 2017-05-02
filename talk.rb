def tom(frequencia, duracao = 100)
  synth :sine, note: hz_to_midi(frequencia),
    sustain: duracao, attack: 0, decay: 0, release: 0
end

# Onda de seno a 440 Hz (Lá 4).
##| tom(440)

# Duas ondas que se somam.
##| tom(440)
##| tom(440)

# Duas ondas que se anulam.
##| tom(440)
##| tom(440.5)

# Onda com duração curta.
##| tom(440, 1)

# O Lá 4 vira o Lá 5 se dobrarmos a frequência.
##| tom(440,1)
##| tom(880,1)

def tom_envelopado(frequencia, duracao = 100)
  attack = duracao * 0.05
  release = duracao * 0.9
  decay = 0
  sustain = duracao - release - decay
  synth :sine,
    note: hz_to_midi(frequencia),
    attack: attack,
    decay: decay,
    release: release,
    sustain: sustain
end

def sino(frequencia = 440,
         duracao = 6,
         serie_harmonica = {1 => 1, 2 => 0.6, 3 => 0.4, 4 => 0.25, 5 => 0.2, 6 => 0.15})
  serie_harmonica.each do |harmonico, proporcao|
    nota = frequencia * harmonico
    tempo = duracao * proporcao
    tom_envelopado(nota, tempo)
  end
end

# Sino padrão
##| sino(300)

# Sino com série harmônica mais realista
##| sino(300, 6, {1 => 1, 2 => 0.6, 3 => 0.4, 4.2 => 0.25, 5.4 => 0.2, 6.8 => 0.15})

# ... e mais agudo
##| sino(600, 6, {1 => 1, 2 => 0.6, 3 => 0.4, 4.2 => 0.25, 5.4 => 0.2, 6.8 => 0.15})

# Com séries harmônicas de duração diferente
##| sino(500, 6, {1 => 0, 2 => 0.6, 3 => 0.4, 4.2 => 0.25, 5.4 => 0.2, 6.8 => 0.15})
##| sino(400, 6, {1 => 0, 2 => 0, 3 => 0.4, 4.2 => 0.25, 5.4 => 0.2, 6.8 => 0.15})

def midi_para_hz(midi)
  8.1757989156 * (2 ** (midi / 12.0))
end

##| puts midi_para_hz(69)

def campainha(midi)
  sino(midi_para_hz(midi), 3, {1 => 0, 2 => 0, 3 => 0.4, 4.2 => 0.25, 5.4 => 0.2, 6.8 => 0.15})
end

##| campainha(69)

def nota(tom, pausa)
  campainha(tom)
  sleep(pausa)
end

def melodia_simples(tons, pausa = 0.5)
  tons.each do |tom|
    nota(tom, pausa)
  end
end

##| melodia_simples(70..77)
##| melodia_simples([77, 76, 75, 74, 73, 72, 71, 70])

def escala(base, intervalos)
  passo = 0
  [base] + intervalos.map do |intervalo|
    passo += intervalo
    base + passo
  end
end

def maior(base)
  escala(base, [2, 2, 1, 2, 2, 2, 1])
end

##| puts maior(70)

dó = 60
##| melodia_simples(maior(dó))

def menor(base)
  escala(base, [2, 1, 2, 2, 1, 2, 2])
end

def blues(base)
  escala(base, [3, 2, 1, 1, 3, 2])
end

def pentatonica(base)
  escala(base, [3, 2, 2, 3, 2])
end

def egipcia(base)
  escala(base, [2, 3, 2, 3, 2])
end

def cromatica(base)
  escala(base, [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1])
end

##| melodia_simples(menor(dó))
##| melodia_simples(blues(dó))
##| melodia_simples(pentatonica(dó))
##| melodia_simples(egipcia(dó))
##| melodia_simples(cromatica(dó))

def melodia_aleatoria(tons, duracao_total, pausa = 0.3)
  duracao = 0.0
  while duracao < duracao_total
    tom = tons.sample
    nota(tom, pausa)
    duracao += pausa
  end
end

##| melodia_aleatoria(cromatica(dó), 6)
##| melodia_aleatoria(maior(dó), 6)
##| melodia_aleatoria(menor(dó), 6)
##| melodia_aleatoria(pentatonica(dó), 6)
##| melodia_aleatoria(egipcia(dó), 6)

def melodia(tons_duracoes)
  tons_duracoes.each do |tom, duracao|
    nota(tom, duracao)
  end
end

def do_re_mi_fa(base)
  notas = [
    0, 2, 4, 5, 5, 5,
    0, 2, 0, 2, 2, 2,
    0, 7, 5, 4, 4, 4,
    0, 2, 4, 5, 5, 5
  ]
  duracoes = [
    0.25, 0.25, 0.25, 0.4, 0.25, 0.5,
    0.25, 0.25, 0.25, 0.4, 0.25, 0.5,
    0.25, 0.25, 0.25, 0.4, 0.25, 0.5,
    0.25, 0.25, 0.25, 0.4, 0.25, 0.5
  ]
  notas.map{|nota| base + nota}.zip(duracoes)
end

##| puts do_re_mi_fa(dó)

##| melodia(do_re_mi_fa(dó))
##| melodia(do_re_mi_fa(dó + 5))

def partitura(notas, duracoes, bpm = 120)
  duracoes_em_segundos = duracoes.map do |duracao|
    duracao / bpm.to_f * 60
  end
  
  notas.zip(duracoes_em_segundos)
end

def frere_jacques(dó)
  escala_maior = maior(dó)
  dó, ré, mi, fá, sol, la = escala_maior
  sol3 = sol - 12
  
  notas = [
    dó, ré, mi, dó,
    dó, ré, mi, dó,
    mi, fá, sol,
    mi, fá, sol,
    sol, la, sol, fá, mi, dó,
    sol, la, sol, fá, mi, dó,
    dó, sol3, dó,
    dó, sol3, dó
  ]
  
  duracoes = [
    1, 1, 1, 1,
    1, 1, 1, 1,
    1, 1, 2,
    1, 1, 2,
    3/4.0, 1/4.0, 1/2.0, 1/2.0, 1, 1,
    3/4.0, 1/4.0, 1/2.0, 1/2.0, 1, 1,
    1, 1, 2,
    1, 1, 2
  ]
  
  partitura(notas, duracoes, 110)
end

##| puts frere_jacques(dó)

##| melodia(frere_jacques(dó))

##| melodia(frere_jacques(dó + 5))

def piano(midi, duracao)
  attack = duracao * 0.05
  release = duracao * 0.9
  decay = 0
  sustain = duracao - release - decay
  synth :piano,
    note: midi,
    attack: attack,
    decay: decay,
    release: release,
    sustain: sustain
  
  sleep(duracao)
end

##| piano(:C4, 1)

def melodia_piano(partituras)
  clave_sol = partituras.first
  clave_fa = partituras.last
  
  in_thread do
    clave_sol.each do |tom, duracao|
      piano(tom, duracao)
    end
  end
  
  in_thread do
    clave_fa.each do |tom, duracao|
      piano(tom, duracao)
    end
  end
end

def eine_kleine_nacht_musik
  notas_clave_sol = [
    :G4,   0, :D4, :G4,   0, :D4,
    :G4, :D4, :G4, :B4, :D5,   0,
    :C5,   0, :A4, :C5,   0, :A4,
    :C5, :A4, :F3, :A4, :D3,   0,
    :G4, :G4, :G4, :B5, :A5, :G4,
  ]
  
  duracoes_clave_sol = [
    1, 1/2.0, 1/2.0, 1, 1/2.0, 1/2.0,
    1/2.0, 1/2.0, 1/2.0, 1/2.0, 1, 1,
    1, 1/2.0, 1/2.0, 1, 1/2.0, 1/2.0,
    1/2.0, 1/2.0, 1/2.0, 1/2.0, 1, 1,
    1, 1, 1/2.0, 1/2.0, 1/2.0, 1/2.0,
  ]
  
  notas_clave_fa = [
    :G3,   0, :D3, :G3,   0, :D3,
    :G3, :D3, :G3, :B4, :D4,   0,
    :C4,   0, :A4, :C4,   0, :A4,
    :C4, :A4, :F3, :A4, :D3,   0,
    :B4, :B4, :B4, :B4, :B4, :B4, :B4, :B4,
  ]
  
  duracoes_clave_fa = [
    1, 1/2.0, 1/2.0, 1, 1/2.0, 1/2.0,
    1/2.0, 1/2.0, 1/2.0, 1/2.0, 1, 1,
    1, 1/2.0, 1/2.0, 1, 1/2.0, 1/2.0,
    1/2.0, 1/2.0, 1/2.0, 1/2.0, 1, 1,
    1/2.0, 1/2.0, 1/2.0, 1/2.0, 1/2.0, 1/2.0, 1/2.0, 1/2.0,
  ]
  
  clave_sol = partitura(notas_clave_sol, duracoes_clave_sol, 125)
  clave_fa  = partitura(notas_clave_fa, duracoes_clave_fa, 125)
  [clave_sol, clave_fa]
end

##| puts eine_kleine_nacht_musik

##| melodia_piano(eine_kleine_nacht_musik)
