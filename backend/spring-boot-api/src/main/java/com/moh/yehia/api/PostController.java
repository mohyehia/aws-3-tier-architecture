package com.moh.yehia.api;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/posts")
public class PostController {
    private final PostRepository postRepository;

    public PostController(PostRepository postRepository) {
        this.postRepository = postRepository;
    }

    @GetMapping
    public List<Post> findAll() {
        return postRepository.findAll();
    }

    @GetMapping("/{postId}")
    public Post findById(@PathVariable int postId) {
        return postRepository.findById(postId).orElse(new Post(0, 0, "Not Found Post Title", "Not Found Post Body"));
    }
}
