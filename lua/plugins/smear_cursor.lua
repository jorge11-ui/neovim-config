return {
  "sphamba/smear-cursor.nvim",
  opts = {
    -- Desativa transições entre buffers ou janelas se estiver a causar "saltos" estranhos
    smear_between_buffers = false,

    -- Mantém apenas para linhas vizinhas (movimentos curtos com h, j, k, l)
    smear_between_neighbor_lines = true,

    -- Desliga o scroll buffer space se estiver a distorcer o texto ao fazer scroll
    scroll_buffer_space = false,

    -- Suporte a símbolos (podes testar 'true' se usares uma Nerd Font completa para ficar menos pixelizado)
    legacy_computing_symbols_support = false,

    -- Desativa no modo de inserção para evitar que o cursor em barra rasure o que estás a escrever
    smear_insert_mode = false,

    -- ── Afinações extra para suavizar e tirar os "bugs" ──
    -- Velocidade de correção (quanto maior, mais rápido o rasto desaparece, evitando "fantasmas")
    stiffness = 0.8, 
    trailing_stiffness = 0.5,
    distance_stop_animating = 0.1,
  },
}
